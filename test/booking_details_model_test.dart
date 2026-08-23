import 'package:flutter_test/flutter_test.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';

void main() {
  group('BookingDetailsModel package contract', () {
    test('parses mixed assigned item source types safely', () {
      final response = BookingDetailsResponseModel.fromJson({
        'success': true,
        'data': {
          'uuid': 'booking-1',
          'reference': '#BK1',
          'assigned_items': [
            {
              'uuid': 'item-normal',
              'source_type': 'normal_service',
              'service': {
                'uuid': 'service-1',
                'name': {'ar': 'تنظيف', 'en': 'Cleaning'},
              },
              'duration_minutes': 30,
              'can_start': true,
            },
            {
              'uuid': 'item-package-2',
              'source_type': 'single_visit_package',
              'covered_by_package': true,
              'service': {'name': 'Service B'},
              'package': {
                'uuid': 'package-1',
                'instance_id': 'instance-1',
                'name': 'Hair package',
                'item_position': 2,
                'base_price': '800',
                'offer_price': '700',
                'effective_price': '700',
                'services': [
                  {
                    'uuid': 'svc-b',
                    'name': 'Service B',
                    'duration_minutes': 45,
                  },
                ],
              },
            },
            {
              'uuid': 'item-session',
              'source_type': 'multi_session',
              'covered_by_package': true,
              'new_charge': '0',
              'service': {'name': 'Laser'},
              'package': {
                'name': 'Laser 10 sessions',
                'session_number': 3,
                'sessions': {
                  'total': 10,
                  'reserved': 1,
                  'used': 2,
                  'completed': 2,
                  'available': 7,
                  'remaining': 7,
                },
              },
            },
            {
              'uuid': 'item-usage',
              'source_type': 'usage_based',
              'usage_recording_required': true,
              'service': {'name': 'Face laser'},
              'usage_package': {
                'name': '1000 pulses',
                'available_units': 700,
                'unit_name': 'pulses',
                'selected_service': {
                  'uuid': 'svc-usage',
                  'name': 'Face laser',
                  'duration_minutes': 50,
                },
              },
            },
            {
              'uuid': 'item-follow',
              'source_type': 'follow_up',
              'service': {'name': 'Follow service'},
              'follow_up': {
                'uuid': 'follow-1',
                'remaining_uses': 1,
                'valid_until': '2026-09-01',
                'original_service': 'Cleaning',
                'original_employee': 'Ahmed',
              },
            },
          ],
          'totals': {'price': '0', 'currency': 'EGP'},
          'actions': {},
        },
      });

      final lines = response.data.serviceLinesForDetails('en');

      expect(lines, hasLength(5));
      expect(lines[0].canStart, isTrue);
      expect(lines[1].isSingleVisitPackage, isTrue);
      expect(lines[1].package?.instanceId, 'instance-1');
      expect(lines[1].package?.services.first.durationMinutes, 45);
      expect(lines[2].isMultiSession, isTrue);
      expect(lines[2].package?.sessions?.remaining, 7);
      expect(lines[3].isUsageBased, isTrue);
      expect(lines[3].usageRecordingRequired, isTrue);
      expect(lines[3].usagePackage?.availableUnits, 700);
      expect(lines[4].isFollowUp, isTrue);
      expect(lines[4].followUp?.originalEmployee, 'Ahmed');
    });

    test('parses nullable metadata without crashing', () {
      final line = BookingServiceLine.fromJson({
        'item_uuid': 'item-null',
        'source_type': 'usage_based',
        'package': null,
        'usage_package': null,
        'follow_up': null,
        'offer_price': null,
      });

      expect(line.package, isNull);
      expect(line.usagePackage, isNull);
      expect(line.followUp, isNull);
      expect(line.sourceType, 'usage_based');
    });

    test('prefers assigned items over legacy services for details', () {
      final response = BookingDetailsResponseModel.fromJson({
        'success': true,
        'data': {
          'uuid': 'booking-1',
          'service': {
            'uuid': 'legacy',
            'name': {'ar': 'قديم', 'en': 'Legacy'},
          },
          'services': [
            {
              'item_uuid': 'legacy-service',
              'name': 'Legacy Flat Service',
              'source_type': 'normal_service',
              'price': '0',
              'duration_minutes': 30,
            },
          ],
          'assigned_items': [
            {
              'uuid': 'assigned-package',
              'service': {
                'uuid': 'service-1',
                'name': {'ar': 'باقة', 'en': 'Package Item'},
              },
              'package': {
                'instance_id': 'instance-1',
                'name': 'Dental Package',
                'item_position': 1,
              },
              'duration_minutes': 45,
            },
          ],
        },
      });

      final lines = response.data.serviceLinesForDetails('en');

      expect(lines, hasLength(1));
      expect(lines.first.itemUuid, 'assigned-package');
      expect(lines.first.name, 'Package Item');
      expect(lines.first.sourceType, 'single_visit_package');
      expect(lines.first.package?.instanceId, 'instance-1');
    });

    test(
      'visit services prefer assigned items metadata over flat services',
      () {
        final visit = BookingVisitModel.fromJson({
          'uuid': 'visit-1',
          'number': 1,
          'services': [
            {
              'item_uuid': 'flat-service',
              'name': 'Flat Service',
              'source_type': 'normal_service',
            },
          ],
          'assigned_items': [
            {
              'uuid': 'assigned-usage',
              'service': {'name': 'Laser'},
              'usage_package': {
                'name': 'Pulse Package',
                'available_units': 700,
                'unit_name': 'pulse',
              },
              'start_at': '2026-08-23T09:30:00+03:00',
              'end_at': '2026-08-23T10:00:00+03:00',
            },
          ],
        });

        expect(visit.services, hasLength(1));
        expect(visit.services.first.itemUuid, 'assigned-usage');
        expect(visit.services.first.sourceType, 'usage_based');
        expect(visit.services.first.scheduledStartAt, isNotEmpty);
      },
    );

    test('booking visits use top level assigned items by visit uuid', () {
      final response = BookingDetailsResponseModel.fromJson({
        'success': true,
        'data': {
          'uuid': 'booking-1',
          'visits': [
            {
              'uuid': 'visit-1',
              'number': 1,
              'services': [
                {
                  'item_uuid': 'flat-laser',
                  'name': 'Face Laser',
                  'source_type': 'normal_service',
                },
              ],
            },
          ],
          'assigned_items': [
            {
              'uuid': 'assigned-laser',
              'visit_uuid': 'visit-1',
              'service': {'name': 'Face Laser'},
              'source_type': 'multi_session',
              'package': {
                'name': 'Face Laser 10 Sessions',
                'type': 'multi_session',
                'session_number': 1,
                'sessions': {'total': 10, 'remaining': 9},
              },
            },
          ],
        },
      });

      final service = response.data.visits.first.services.first;

      expect(service.itemUuid, 'assigned-laser');
      expect(service.sourceType, 'multi_session');
      expect(service.package?.name, 'Face Laser 10 Sessions');
    });
  });
}
