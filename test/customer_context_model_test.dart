import 'package:flutter_test/flutter_test.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/data/models/customer_context_model.dart';

void main() {
  group('CustomerContextModel', () {
    test(
      'parses capabilities, purchases, assignable packages and follow ups',
      () {
        final response = CustomerContextResponseModel.fromJson({
          'success': true,
          'data': {
            'customer': {
              'uuid': 'customer-1',
              'name': 'Ahmed',
              'phone': '0100',
              'email': null,
            },
            'capabilities': {
              'can_view_customer_packages': true,
              'can_assign_customer_package': true,
              'can_view_customer_follow_ups': true,
              'can_record_usage': true,
            },
            'packages': [
              {
                'uuid': 'purchase-session',
                'name': 'Laser 10 sessions',
                'type': 'multi_session',
                'payment_status': 'partial',
                'paid_amount': '300',
                'remaining_amount': '700',
                'sessions': {
                  'total': 10,
                  'reserved': 1,
                  'used': 2,
                  'available': 7,
                  'remaining': 7,
                },
              },
              {
                'uuid': 'purchase-usage',
                'name': '1000 pulses',
                'type': 'usage_based',
                'payment_status': 'unpaid',
                'usage': {
                  'available': 700,
                  'unit_name': 'pulses',
                  'total_purchased': 1000,
                  'total_consumed': 300,
                },
              },
            ],
            'assignable_packages': [
              {
                'uuid': 'assign-usage',
                'name': '1000 pulses',
                'type': 'usage_based',
                'price': '1000',
                'currency': 'EGP',
                'initial_units': 1000,
                'unit_name': 'pulses',
              },
              {
                'uuid': 'assign-single',
                'name': 'Single package',
                'type': 'single_visit',
              },
            ],
            'follow_ups': [
              {
                'uuid': 'follow-1',
                'service_name': 'Cleaning',
                'status': 'active',
                'available_count': 1,
                'recommended_period_ended': true,
              },
            ],
          },
        });

        expect(response.data.customer.name, 'Ahmed');
        expect(response.data.capabilities.canAssignCustomerPackage, isTrue);
        expect(response.data.packages, hasLength(2));
        expect(response.data.packages.first.sessions?.remaining, 7);
        expect(response.data.packages[1].usage?.available, 700);
        expect(response.data.assignablePackages, hasLength(1));
        expect(response.data.assignablePackages.first.type, 'usage_based');
        expect(response.data.followUps.first.recommendedPeriodEnded, isTrue);
      },
    );
  });
}
