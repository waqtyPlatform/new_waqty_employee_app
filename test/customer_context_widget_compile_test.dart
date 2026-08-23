import 'package:flutter_test/flutter_test.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_customer_visits_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_details_body_widget.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/ui/widgets/customer_context_bottom_sheet.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/ui/widgets/customer_package_card_widget.dart';

void main() {
  test('customer context widgets compile', () {
    expect(CustomerContextBottomSheet, isNotNull);
    expect(CustomerPackageCardWidget, isNotNull);
    expect(BookingCustomerVisitsWidget, isNotNull);
    expect(BookingDetailsBodyWidget, isNotNull);
  });
}
