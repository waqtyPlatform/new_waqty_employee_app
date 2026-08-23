import 'package:flutter_test/flutter_test.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_addable_items_response_model.dart';

void main() {
  test(
    'parses addable visit items by tab without dropping nullable fields',
    () {
      final response = BookingAddableItemsResponseModel.fromJson({
        'success': true,
        'data': {
          'booking_uuid': 'booking-1',
          'visit_uuid': 'visit-1',
          'scheduled_at': '2026-08-23T10:30:00+03:00',
          'customer': {'uuid': 'customer-1', 'name': 'Ahmed'},
          'services': [
            {
              'uuid': 'service-1',
              'item_type': 'normal_service',
              'source_type': 'normal_service',
              'source_uuid': 'service-source-1',
              'name': 'كشف أسنان',
              'category': 'أسنان',
              'duration_minutes': 30,
              'price': '300.00',
              'currency': 'EGP',
            },
          ],
          'packages_and_offers': [
            {
              'uuid': 'package-1',
              'item_type': 'package_item',
              'source_type': 'single_visit_package',
              'source_uuid': 'package-source-1',
              'name': 'باقة تنظيف وكشف',
              'type': 'single_visit',
              'base_price': 800,
              'effective_price': '700.00',
              'has_active_offer': true,
              'offer': {'uuid': 'offer-1', 'price': 700, 'ends_at': null},
              'total_duration_minutes': 75,
              'sessions_included': null,
              'initial_units': null,
              'unit_code': null,
              'services': [
                {'uuid': 'svc-a', 'name': 'كشف', 'duration_minutes': 30},
              ],
            },
          ],
          'customer_packages': [
            {
              'uuid': 'purchase-1',
              'item_type': 'package_session',
              'source_type': 'multi_session',
              'source_uuid': 'purchase-source-1',
              'name': 'ليزر وجه 10 جلسات',
              'type': 'multi_session',
              'price': 2000,
              'paid_amount': '1000',
              'remaining_amount': '1000',
              'payment_status': 'partial',
              'sessions': {
                'available': 3,
                'unit_name': {'ar': 'جلسة'},
              },
              'usage': null,
              'services': [],
            },
          ],
          'follow_ups': [
            {
              'uuid': 'follow-1',
              'item_type': 'follow_up',
              'source_type': 'follow_up',
              'source_uuid': 'follow-source-1',
              'status': 'active',
              'available_count': 1,
              'valid_from': null,
              'valid_until': '2026-09-03T23:59:59+03:00',
              'after_expiry_policy': 'allow',
              'recommended_period_ended': true,
              'employee_rule': 'same_employee_required',
              'price_type': 'free',
              'price': 0,
              'service': {'uuid': 'service-follow', 'name': 'متابعة'},
              'source': {'booking_uuid': 'booking-old'},
            },
          ],
        },
      });

      final data = response.data;

      expect(data.bookingUuid, 'booking-1');
      expect(data.services.single.itemType, 'normal_service');
      expect(data.services.single.sourceUuid, 'service-source-1');
      expect(data.services.single.price, '300.00');
      expect(data.packagesAndOffers.single.itemType, 'package_item');
      expect(data.packagesAndOffers.single.sourceUuid, 'package-source-1');
      expect(data.packagesAndOffers.single.basePrice, '800');
      expect(data.packagesAndOffers.single.offer?.price, '700');
      expect(data.customerPackages.single.itemType, 'package_session');
      expect(data.customerPackages.single.sourceUuid, 'purchase-source-1');
      expect(data.customerPackages.single.sessions?.available, 3);
      expect(data.customerPackages.single.sessions?.unitName, 'جلسة');
      expect(data.followUps.single.itemType, 'follow_up');
      expect(data.followUps.single.sourceUuid, 'follow-source-1');
      expect(data.followUps.single.recommendedPeriodEnded, isTrue);
      expect(data.followUps.single.source?.bookingUuid, 'booking-old');
      expect(data.followUps.single.source?.bookingItemUuid, '');
    },
  );

  test('falls back to item metadata when addable api omits it', () {
    final response = BookingAddableItemsResponseModel.fromJson({
      'success': true,
      'data': {
        'packages_and_offers': [
          {'uuid': 'package-1', 'type': 'single_visit', 'services': []},
        ],
        'customer_packages': [
          {'uuid': 'purchase-1', 'type': 'usage_based', 'services': []},
        ],
        'follow_ups': [
          {
            'uuid': 'follow-1',
            'service': {'uuid': 'service-1'},
          },
        ],
      },
    });

    expect(
      response.data.packagesAndOffers.single.sourceType,
      'single_visit_package',
    );
    expect(response.data.packagesAndOffers.single.itemType, 'package_item');
    expect(response.data.packagesAndOffers.single.sourceUuid, 'package-1');
    expect(response.data.customerPackages.single.itemType, 'usage_package');
    expect(response.data.customerPackages.single.sourceType, 'usage_based');
    expect(response.data.customerPackages.single.sourceUuid, 'purchase-1');
    expect(response.data.followUps.single.itemType, 'follow_up');
    expect(response.data.followUps.single.sourceType, 'follow_up');
    expect(response.data.followUps.single.sourceUuid, 'follow-1');
  });
}
