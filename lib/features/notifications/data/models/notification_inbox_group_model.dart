import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_action_model.dart';

class NotificationInboxGroupModel {
  final String title;
  final List<NotificationInboxItemModel> items;

  const NotificationInboxGroupModel({required this.title, required this.items});
}

class NotificationInboxItemModel {
  final String uuid;
  final String type;
  final String eventType;
  final String category;
  final String title;
  final String message;
  final String time;
  final DateTime? createdAt;
  final String? actionLabel;
  final bool isUnread;
  final NotificationActionModel action;
  final Map<String, dynamic> entity;
  final Map<String, dynamic> data;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const NotificationInboxItemModel({
    this.uuid = '',
    this.type = '',
    this.eventType = '',
    this.category = '',
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.createdAt,
    this.actionLabel,
    this.isUnread = false,
    this.action = const NotificationActionModel(
      type: '',
      screen: '',
      fallbackScreen: 'notifications',
      params: {},
    ),
    this.entity = const {},
    this.data = const {},
  });

  factory NotificationInboxItemModel.fromJson(Map<String, dynamic> json) {
    final type = _asString(json['type']);
    final eventType = _asString(json['event_type'] ?? type);
    final category = _asString(json['category']);
    final action = NotificationActionModel.fromJson(_asMap(json['action']));
    final createdAt = DateTime.tryParse(_asString(json['created_at']));
    final isRead = _asBool(json['is_read']);
    return NotificationInboxItemModel(
      uuid: _asString(json['uuid'] ?? json['id']),
      type: type,
      eventType: eventType,
      category: category,
      title: _asString(json['title']),
      message: _asString(json['body'] ?? json['message']),
      time: _asString(json['created_at']),
      createdAt: createdAt,
      actionLabel: _asString(json['action_label']).isEmpty
          ? null
          : _asString(json['action_label']),
      isUnread: !isRead,
      action: action,
      entity: _asMap(json['entity']),
      data: _asMap(json['data']),
      icon: _iconFor(type: eventType, category: category),
      iconColor: _iconColorFor(type: eventType, category: category),
      backgroundColor: _backgroundColorFor(type: eventType, category: category),
    );
  }

  factory NotificationInboxItemModel.booking({
    required String title,
    required String message,
    required String time,
    String? actionLabel,
    bool isUnread = false,
  }) {
    return NotificationInboxItemModel(
      title: title,
      message: message,
      time: time,
      actionLabel: actionLabel,
      isUnread: isUnread,
      icon: Icons.calendar_month_outlined,
      iconColor: AppColors.blueColor506,
      backgroundColor: AppColors.blueColor5055,
    );
  }

  factory NotificationInboxItemModel.review({
    required String title,
    required String message,
    required String time,
    String? actionLabel,
    bool isUnread = false,
  }) {
    return NotificationInboxItemModel(
      title: title,
      message: message,
      time: time,
      actionLabel: actionLabel,
      isUnread: isUnread,
      icon: Icons.star_border_rounded,
      iconColor: AppColors.warningColor1001,
      backgroundColor: AppColors.warningColor1002,
    );
  }

  factory NotificationInboxItemModel.cancel({
    required String title,
    required String message,
    required String time,
    String? actionLabel,
    bool isUnread = false,
  }) {
    return NotificationInboxItemModel(
      title: title,
      message: message,
      time: time,
      actionLabel: actionLabel,
      isUnread: isUnread,
      icon: Icons.cancel_outlined,
      iconColor: AppColors.errorColor2002,
      backgroundColor: AppColors.errorColor2003,
    );
  }

  factory NotificationInboxItemModel.shift({
    required String title,
    required String message,
    required String time,
    String? actionLabel,
  }) {
    return NotificationInboxItemModel(
      title: title,
      message: message,
      time: time,
      actionLabel: actionLabel,
      icon: Icons.access_time_rounded,
      iconColor: AppColors.warningColor1001,
      backgroundColor: AppColors.warningColor1002,
    );
  }

  factory NotificationInboxItemModel.attendance({
    required String title,
    required String message,
    required String time,
    String? actionLabel,
  }) {
    return NotificationInboxItemModel(
      title: title,
      message: message,
      time: time,
      actionLabel: actionLabel,
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.greenColor500,
      backgroundColor: AppColors.greenColor5005,
    );
  }

  factory NotificationInboxItemModel.payment({
    required String title,
    required String message,
    required String time,
    String? actionLabel,
  }) {
    return NotificationInboxItemModel(
      title: title,
      message: message,
      time: time,
      actionLabel: actionLabel,
      icon: Icons.payments_outlined,
      iconColor: AppColors.greenColor500,
      backgroundColor: AppColors.greenColor5005,
    );
  }

  factory NotificationInboxItemModel.schedule({
    required String title,
    required String message,
    required String time,
    String? actionLabel,
  }) {
    return NotificationInboxItemModel(
      title: title,
      message: message,
      time: time,
      actionLabel: actionLabel,
      icon: Icons.edit_calendar_outlined,
      iconColor: AppColors.blueColor506,
      backgroundColor: AppColors.blueColor5055,
    );
  }

  factory NotificationInboxItemModel.payslip({
    required String title,
    required String message,
    required String time,
    String? actionLabel,
  }) {
    return NotificationInboxItemModel(
      title: title,
      message: message,
      time: time,
      actionLabel: actionLabel,
      icon: Icons.receipt_long_outlined,
      iconColor: AppColors.greenColor500,
      backgroundColor: AppColors.greenColor5005,
    );
  }

  factory NotificationInboxItemModel.announcement({
    required String title,
    required String message,
    required String time,
  }) {
    return NotificationInboxItemModel(
      title: title,
      message: message,
      time: time,
      icon: Icons.campaign_outlined,
      iconColor: AppColors.greyColor500,
      backgroundColor: AppColors.greyColorFA,
    );
  }

  factory NotificationInboxItemModel.deduction({
    required String title,
    required String message,
    required String time,
    String? actionLabel,
  }) {
    return NotificationInboxItemModel(
      title: title,
      message: message,
      time: time,
      actionLabel: actionLabel,
      icon: Icons.remove_circle_outline,
      iconColor: AppColors.errorColor2002,
      backgroundColor: AppColors.errorColor2003,
    );
  }
}

IconData _iconFor({required String type, required String category}) {
  if (category == 'booking' || type.startsWith('booking_')) {
    return Icons.calendar_month_outlined;
  }
  if (type.contains('attendance')) return Icons.check_circle_outline_rounded;
  if (type.contains('support')) return Icons.support_agent_outlined;
  if (type.contains('shift') || type.contains('schedule')) {
    return Icons.access_time_rounded;
  }
  if (type.contains('announcement')) return Icons.campaign_outlined;
  return Icons.notifications_none_rounded;
}

Color _iconColorFor({required String type, required String category}) {
  if (type.contains('cancel') || type.contains('rejected')) {
    return AppColors.errorColor2002;
  }
  if (type.contains('attendance')) return AppColors.greenColor500;
  if (category == 'booking' || type.startsWith('booking_')) {
    return AppColors.blueColor506;
  }
  if (type.contains('shift') || type.contains('schedule')) {
    return AppColors.warningColor1001;
  }
  return AppColors.greyColor500;
}

Color _backgroundColorFor({required String type, required String category}) {
  if (type.contains('cancel') || type.contains('rejected')) {
    return AppColors.errorColor2003;
  }
  if (type.contains('attendance')) return AppColors.greenColor5005;
  if (category == 'booking' || type.startsWith('booking_')) {
    return AppColors.blueColor5055;
  }
  if (type.contains('shift') || type.contains('schedule')) {
    return AppColors.warningColor1002;
  }
  return AppColors.greyColorFA;
}

String _asString(dynamic value) => value?.toString() ?? '';

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().toLowerCase().trim();
  return text == 'true' || text == '1' || text == 'yes';
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}
