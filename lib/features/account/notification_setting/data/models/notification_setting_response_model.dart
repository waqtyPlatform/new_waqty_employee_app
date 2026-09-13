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
  final bool shiftChanges;
  final bool shiftStartReminders;
  final bool leaveAndRequestUpdates;
  final bool managerAnnouncements;

  const NotificationSettingsModel({
    required this.newBookingsAssigned,
    required this.bookingCancellations,
    required this.appointmentReminders,
    required this.shiftChanges,
    required this.shiftStartReminders,
    required this.leaveAndRequestUpdates,
    required this.managerAnnouncements,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      newBookingsAssigned: json['new_bookings_assigned'] ?? false,
      bookingCancellations: json['booking_cancellations'] ?? false,
      appointmentReminders: json['appointment_reminders'] ?? false,
      shiftChanges: json['shift_changes'] ?? false,
      shiftStartReminders: json['shift_start_reminders'] ?? false,
      leaveAndRequestUpdates: json['leave_and_request_updates'] ?? false,
      managerAnnouncements: json['manager_announcements'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      NotificationSettingKey.newBookingsAssigned: newBookingsAssigned,
      NotificationSettingKey.bookingCancellations: bookingCancellations,
      NotificationSettingKey.appointmentReminders: appointmentReminders,
      NotificationSettingKey.shiftChanges: shiftChanges,
      NotificationSettingKey.shiftStartReminders: shiftStartReminders,
      NotificationSettingKey.leaveAndRequestUpdates: leaveAndRequestUpdates,
      NotificationSettingKey.managerAnnouncements: managerAnnouncements,
    };
  }

  bool valueOf(String key) {
    return switch (key) {
      NotificationSettingKey.newBookingsAssigned => newBookingsAssigned,
      NotificationSettingKey.bookingCancellations => bookingCancellations,
      NotificationSettingKey.appointmentReminders => appointmentReminders,
      NotificationSettingKey.shiftChanges => shiftChanges,
      NotificationSettingKey.shiftStartReminders => shiftStartReminders,
      NotificationSettingKey.leaveAndRequestUpdates => leaveAndRequestUpdates,
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
  static const shiftChanges = 'shift_changes';
  static const shiftStartReminders = 'shift_start_reminders';
  static const leaveAndRequestUpdates = 'leave_and_request_updates';
  static const managerAnnouncements = 'manager_announcements';
}
