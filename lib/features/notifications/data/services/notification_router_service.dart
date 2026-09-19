import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/features/notifications/data/services/notification_center_service.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_action_model.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_inbox_group_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/repo/booking_details_repo.dart';
import 'package:new_waqty_employee_app/features/notifications/data/repo/notifications_repo.dart';
import 'package:new_waqty_employee_app/my_app.dart';

class NotificationRouterService {
  final NotificationsRepo _repo;
  final BookingDetailsRepo _bookingDetailsRepo;

  NotificationRouterService(this._repo, this._bookingDetailsRepo);

  final Map<String, DateTime> _handledNotificationIds = <String, DateTime>{};
  Map<String, dynamic>? _pendingPayload;

  Future<void> handleApiNotification(NotificationInboxItemModel item) async {
    final payload = <String, dynamic>{
      'notification_id': item.uuid,
      'notification_uuid': item.uuid,
      'type': item.type,
      'event_type': item.eventType,
      'category': item.category,
      'entity_type': item.entity['type'],
      'entity_id': item.entity['id'] ?? item.entity['uuid'],
      'booking_id': item.entity['booking_id'] ?? item.entity['booking_uuid'],
      'shift_id': item.entity['shift_id'] ?? item.entity['shift_uuid'],
      ...item.action.params,
      'target_screen': item.action.screen,
      'fallback_screen': item.action.fallbackScreen,
    };
    await handlePayload(payload, markRead: false, apiNotification: item);
  }

  Future<void> handlePayload(
    Map<String, dynamic> payload, {
    bool markRead = true,
    NotificationInboxItemModel? apiNotification,
  }) async {
    final notificationId = _notificationId(payload);
    if (notificationId.isNotEmpty) {
      final handledAt = _handledNotificationIds[notificationId];
      if (handledAt != null &&
          DateTime.now().difference(handledAt) <
              const Duration(milliseconds: 1200)) {
        return;
      }
      _handledNotificationIds[notificationId] = DateTime.now();
    }

    if (!await _hasAuthenticatedSession()) {
      _pendingPayload = payload;
      return;
    }

    final navigator = await _waitForNavigator();
    if (navigator == null) {
      _pendingPayload = payload;
      return;
    }

    NotificationInboxItemModel? readNotification;
    if (markRead && notificationId.isNotEmpty) {
      final markReadResult = await _repo.markRead(
        uuid: notificationId,
        languageCode: AppLanguage.currentCode,
      );
      markReadResult.fold((_) {}, (notification) {
        readNotification = notification;
      });
      unawaited(getIt<NotificationCenterService>().refreshUnreadCount());
    }

    final action = NotificationActionModel.fromFlatData(payload);
    final attendanceAction = _asString(payload['attendance_action']);
    final eventType = attendanceAction.isNotEmpty
        ? attendanceAction
        : _firstString(payload, const ['event_type', 'type']);
    final screenOverride = _screenOverrideForEvent(eventType);
    final screen = screenOverride.isNotEmpty
        ? screenOverride
        : action.screen.isNotEmpty
        ? action.screen
        : _screenForEvent(
            eventType,
            entityType: _asString(payload['entity_type']),
          );
    final didNavigate = await _navigate(
      navigator,
      screen,
      payload,
      notification: apiNotification ?? readNotification,
    );
    if (!didNavigate) {
      _openNotifications(navigator);
      _showFallbackMessage();
    }
  }

  Future<void> flushPendingPayload() async {
    final payload = _pendingPayload;
    if (payload == null) return;
    _pendingPayload = null;
    await handlePayload(payload);
  }

  void clearAccountState() {
    _pendingPayload = null;
    _handledNotificationIds.clear();
  }

  Future<void> handleLocalPayload(String? payload) async {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        await handlePayload(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
  }

  Future<bool> _navigate(
    NavigatorState navigator,
    String screen,
    Map<String, dynamic> payload, {
    NotificationInboxItemModel? notification,
  }) async {
    switch (_normalizeScreen(screen)) {
      case 'booking_details':
        final bookingId = _firstString(payload, const [
          'booking_id',
          'booking_uuid',
          'entity_id',
        ]);
        if (bookingId.isEmpty) return false;
        if (!await _canOpenBooking(bookingId)) return false;
        navigator.pushNamed(
          Routes.bookingDetailsScreen,
          arguments: {'uuid': bookingId},
        );
        return true;
      case 'employee_schedule':
        navigator.pushNamed(Routes.workingHoursScreen);
        return true;
      case 'employee_requests':
        navigator.pushNamed(Routes.myRequestsScreen);
        return true;
      case 'employee_package_details':
        final packageId = _firstString(payload, const [
          'package_id',
          'package_uuid',
          'entity_id',
        ]);
        if (packageId.isEmpty) return false;
        navigator.pushNamed(
          Routes.employeePackageDetailsScreen,
          arguments: {'uuid': packageId},
        );
        return true;
      case 'attendance':
        navigator.pushNamed(Routes.attendanceScreen);
        return true;
      case 'bug_reports':
        navigator.pushNamed(Routes.reportBugScreen);
        return true;
      case 'contact_messages':
        navigator.pushNamed(Routes.contactManagerScreen);
        return true;
      case 'reviews':
        navigator.pushNamed(Routes.myReviewsScreen);
        return true;
      case 'payslips':
        navigator.pushNamed(Routes.payslipsScreen);
        return true;
      case 'bonuses':
        navigator.pushNamed(Routes.bonusesScreen);
        return true;
      case 'deductions':
        navigator.pushNamed(Routes.deductionsScreen);
        return true;
      case 'shift_details':
        final shiftId = _firstString(payload, const [
          'shift_id',
          'shift_uuid',
          'entity_id',
        ]);
        if (shiftId.isEmpty) return false;
        navigator.pushNamed(
          Routes.shiftDetailsScreen,
          arguments: {'shiftId': shiftId},
        );
        return true;
      case 'notification_details':
        if (notification == null) return false;
        navigator.pushNamed(
          Routes.notificationDetailsScreen,
          arguments: {'notification': notification},
        );
        return true;
      case 'notifications':
        _openNotifications(navigator);
        return true;
      default:
        return false;
    }
  }

  Future<bool> _canOpenBooking(String bookingId) async {
    final result = await _bookingDetailsRepo.getBookingDetails(bookingId);
    return result.fold((_) => false, (_) => true);
  }

  void _openNotifications(NavigatorState navigator) {
    navigator.pushNamed(Routes.notificationsScreen);
  }

  String _screenForEvent(String eventType, {String entityType = ''}) {
    if (eventType.startsWith('attendance_')) return 'attendance';
    if (eventType.startsWith('early_departure_')) return 'attendance';
    if (eventType.contains('review')) return 'reviews';
    if (eventType.contains('payslip')) return 'payslips';
    if (eventType.contains('bonus')) return 'bonuses';
    if (eventType.contains('deduction')) return 'deductions';
    if (eventType.startsWith('package_')) return 'employee_package_details';

    switch (eventType) {
      case 'missing_clock_in':
        return 'attendance';
      case 'new_booking':
      case 'booking_assigned':
      case 'booking_updated':
      case 'booking_rescheduled':
      case 'booking_cancelled':
      case 'booking_reassigned':
      case 'booking_reminder':
        return 'booking_details';
      case 'booking_unassigned':
      case 'shift_cancelled':
      case 'schedule_updated':
      case 'leave_rejected':
      case 'leave_updated':
        return 'employee_schedule';
      case 'leave_approved':
        return 'employee_requests';
      case 'shift_assigned':
      case 'shift_updated':
        return 'shift_details';
      case 'announcement':
        return 'notification_details';
      case 'support_updated':
        if (entityType == 'bug_report') return 'bug_reports';
        if (entityType == 'contact_message') return 'contact_messages';
        return 'notifications';
      default:
        return 'notifications';
    }
  }

  String _screenOverrideForEvent(String eventType) {
    if (eventType == 'schedule_updated') return 'employee_schedule';
    if (eventType == 'leave_approved') return 'employee_requests';
    if (eventType == 'missing_clock_in') return 'attendance';
    if (eventType.startsWith('attendance_')) return 'attendance';
    if (eventType.startsWith('early_departure_')) return 'attendance';
    return '';
  }

  String _normalizeScreen(String screen) {
    switch (screen.trim()) {
      case 'booking':
      case 'booking_detail':
      case 'booking_details':
        return 'booking_details';
      case 'schedule':
      case 'employee_schedule':
      case 'my_bookings':
        return 'employee_schedule';
      case 'employee_requests':
      case 'requests':
      case 'my_requests':
        return 'employee_requests';
      case 'employee_package_details':
      case 'package_details':
      case 'my_package_details':
        return 'employee_package_details';
      case 'shift':
      case 'shift_detail':
      case 'shift_details':
        return 'shift_details';
      case 'review':
      case 'reviews':
      case 'my_reviews':
      case 'employee_reviews':
        return 'reviews';
      case 'payslip':
      case 'payslips':
      case 'payslip_details':
        return 'payslips';
      case 'bonus':
      case 'bonuses':
        return 'bonuses';
      case 'deduction':
      case 'deductions':
        return 'deductions';
      default:
        return screen.trim();
    }
  }

  Future<bool> _hasAuthenticatedSession() async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    return token.isNotEmpty;
  }

  Future<NavigatorState?> _waitForNavigator() async {
    for (var i = 0; i < 20; i++) {
      final navigator = navigatorKey.currentState;
      if (navigator != null) return navigator;
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }
    return null;
  }

  void _showFallbackMessage() {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    AppConstant.toast(
      context.tr('notificationInbox.resourceUnavailable'),
      false,
      context,
    );
  }

  String _notificationId(Map<String, dynamic> payload) {
    return _firstString(payload, const [
      'notification_id',
      'notification_uuid',
      'uuid',
      'id',
    ]);
  }

  String _firstString(Map<String, dynamic> payload, List<String> keys) {
    for (final key in keys) {
      final value = _asString(payload[key]);
      if (value.isNotEmpty) return value;
    }
    return '';
  }
}

String _asString(dynamic value) => value?.toString() ?? '';
