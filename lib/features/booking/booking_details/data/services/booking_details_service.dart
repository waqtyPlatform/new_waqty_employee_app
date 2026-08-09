import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/services_with_prices_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/services/booking_details_api_end_points.dart';

class BookingDetailsService {
  ApiConsumer apiConsumer;

  BookingDetailsService({required this.apiConsumer});

  Future<BookingDetailsResponseModel> getBookingDetails(String uuid) async {
    final response = await apiConsumer.get(
      BookingDetailsApiEndPoints.getBookingDetails(uuid),
      await _headers(),
    );

    if (response.statusCode == StatusCode.ok) {
      return BookingDetailsResponseModel.fromJson(_decodeMap(response.body));
    } else {
      _throwServerFailure(response);
    }
  }

  Future<BookingDetailsResponseModel> updateBookingStatus({
    required String uuid,
    required String status,
  }) async {
    final response = await apiConsumer.patch(
      BookingDetailsApiEndPoints.updateBookingStatus(uuid),
      {'status': status},
      await _headers(),
    );
    return _parseBookingMutationResponse(response);
  }

  Future<BookingDetailsResponseModel> runBookingAction({
    required String uuid,
    required BookingDetailsAction action,
  }) async {
    final response = await apiConsumer.patch(
      _actionEndpoint(uuid, action),
      null,
      await _headers(),
    );
    return _parseBookingMutationResponse(response);
  }

  Future<BookingDetailsResponseModel> addService({
    required String uuid,
    required String serviceUuid,
    String? visitUuid,
  }) async {
    final response = await apiConsumer.post(
      BookingDetailsApiEndPoints.addService(uuid),
      {'service_uuid': serviceUuid, 'visit_uuid': visitUuid},
      await _headers(),
    );
    return _parseBookingMutationResponse(response);
  }

  Future<void> runVisitAction({
    required String visitUuid,
    required BookingVisitAction action,
  }) async {
    final response = await apiConsumer.patch(
      _visitActionEndpoint(visitUuid, action),
      null,
      await _headers(),
    );
    _throwIfFailed(response);
  }

  Future<void> runBookingItemAction({
    required String itemUuid,
    required BookingItemAction action,
  }) async {
    final response = await apiConsumer.patch(
      action == BookingItemAction.start
          ? BookingDetailsApiEndPoints.startBookingItem(itemUuid)
          : BookingDetailsApiEndPoints.endBookingItem(itemUuid),
      null,
      await _headers(),
    );
    _throwIfFailed(response);
  }

  Future<BookingCustomerReviewModel> submitCustomerReview({
    required String visitUuid,
    required int rating,
    required String comment,
  }) async {
    final response = await apiConsumer.put(
      BookingDetailsApiEndPoints.visitCustomerReview(visitUuid),
      {'rating': rating, 'comment': comment},
      await _headers(),
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return BookingCustomerReviewModel.fromJson(
        _asMap(_decodeMap(response.body)['data']),
      );
    }

    _throwServerFailure(response);
  }

  BookingDetailsResponseModel _parseBookingMutationResponse(dynamic response) {
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return BookingDetailsResponseModel.fromJson(_decodeMap(response.body));
    } else {
      _throwServerFailure(response);
    }
  }

  void _throwIfFailed(dynamic response) {
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return;
    }
    _throwServerFailure(response);
  }

  Future<ServicesWithPricesResponseModel> getServicesWithPrices(
    String uuid,
    int page,
  ) async {
    final response = await apiConsumer.get(
      BookingDetailsApiEndPoints.getServicesWithPrices(uuid, page),
      await _headers(),
    );

    if (response.statusCode == StatusCode.ok) {
      return ServicesWithPricesResponseModel.fromJson(
        _decodeMap(response.body),
      );
    } else {
      _throwServerFailure(response);
    }
  }

  Never _throwServerFailure(dynamic response) {
    String message = '';
    try {
      final decodedBody = jsonDecode(response.body);
      if (decodedBody is Map<String, dynamic>) {
        message = decodedBody['message']?.toString() ?? '';
      }
    } catch (_) {}

    throw ServerException(
      serverFailure: ServerFailure(
        message: message.isEmpty ? 'Server error' : message,
      ),
    );
  }

  Map<String, dynamic> _decodeMap(String body) {
    try {
      final decodedBody = jsonDecode(body);
      return _asMap(decodedBody);
    } catch (_) {
      throw ServerException(
        serverFailure: ServerFailure(message: 'Invalid server response'),
      );
    }
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  Future<Map<String, String>> _headers() async {
    return {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      ConstantKeys.contentType: ConstantKeys.applicationJson,
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
    };
  }

  String _actionEndpoint(String uuid, BookingDetailsAction action) {
    switch (action) {
      case BookingDetailsAction.start:
        return BookingDetailsApiEndPoints.startBooking(uuid);
      case BookingDetailsAction.complete:
        return BookingDetailsApiEndPoints.completeBooking(uuid);
      case BookingDetailsAction.noShow:
        return BookingDetailsApiEndPoints.markNoShow(uuid);
      case BookingDetailsAction.cancel:
        return BookingDetailsApiEndPoints.cancelBooking(uuid);
    }
  }

  String _visitActionEndpoint(String visitUuid, BookingVisitAction action) {
    switch (action) {
      case BookingVisitAction.checkIn:
        return BookingDetailsApiEndPoints.checkInVisit(visitUuid);
      case BookingVisitAction.noShow:
        return BookingDetailsApiEndPoints.visitNoShow(visitUuid);
      case BookingVisitAction.cancel:
        return BookingDetailsApiEndPoints.cancelVisit(visitUuid);
    }
  }
}

enum BookingDetailsAction { start, complete, noShow, cancel }

enum BookingVisitAction { checkIn, noShow, cancel }

enum BookingItemAction { start, end }
