class NotificationSettingResponseModel {
  final bool success;
  final NotificationSettingsModel data;

  const NotificationSettingResponseModel({
    required this.success,
    required this.data,
  });

  factory NotificationSettingResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingResponseModel(
      success: json['success'] ?? false,
      data: NotificationSettingsModel.fromJson(
        json['data']?['notification_settings'] ?? {},
      ),
    );
  }
}

class NotificationSettingsModel {
  final bool newBookingsAssigned;
  final bool bookingCancellations;
  final bool appointmentReminders;
  final bool shiftStartReminders;
  final bool newReviews;
  final bool payslipAvailable;
  final bool managerAnnouncements;

  const NotificationSettingsModel({
    required this.newBookingsAssigned,
    required this.bookingCancellations,
    required this.appointmentReminders,
    required this.shiftStartReminders,
    required this.newReviews,
    required this.payslipAvailable,
    required this.managerAnnouncements,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      newBookingsAssigned: json['new_bookings_assigned'] ?? false,
      bookingCancellations: json['booking_cancellations'] ?? false,
      appointmentReminders: json['appointment_reminders'] ?? false,
      shiftStartReminders: json['shift_start_reminders'] ?? false,
      newReviews: json['new_reviews'] ?? false,
      payslipAvailable: json['payslip_available'] ?? false,
      managerAnnouncements: json['manager_announcements'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      NotificationSettingKey.newBookingsAssigned: newBookingsAssigned,
      NotificationSettingKey.bookingCancellations: bookingCancellations,
      NotificationSettingKey.appointmentReminders: appointmentReminders,
      NotificationSettingKey.shiftStartReminders: shiftStartReminders,
      NotificationSettingKey.newReviews: newReviews,
      NotificationSettingKey.payslipAvailable: payslipAvailable,
      NotificationSettingKey.managerAnnouncements: managerAnnouncements,
    };
  }

  bool valueOf(String key) {
    return switch (key) {
      NotificationSettingKey.newBookingsAssigned => newBookingsAssigned,
      NotificationSettingKey.bookingCancellations => bookingCancellations,
      NotificationSettingKey.appointmentReminders => appointmentReminders,
      NotificationSettingKey.shiftStartReminders => shiftStartReminders,
      NotificationSettingKey.newReviews => newReviews,
      NotificationSettingKey.payslipAvailable => payslipAvailable,
      NotificationSettingKey.managerAnnouncements => managerAnnouncements,
      _ => false,
    };
  }

  NotificationSettingsModel copyWithKey(String key, bool value) {
    return NotificationSettingsModel.fromJson({...toJson(), key: value});
  }
}

class NotificationSettingKey {
  const NotificationSettingKey._();

  static const newBookingsAssigned = 'new_bookings_assigned';
  static const bookingCancellations = 'booking_cancellations';
  static const appointmentReminders = 'appointment_reminders';
  static const shiftStartReminders = 'shift_start_reminders';
  static const newReviews = 'new_reviews';
  static const payslipAvailable = 'payslip_available';
  static const managerAnnouncements = 'manager_announcements';
}
