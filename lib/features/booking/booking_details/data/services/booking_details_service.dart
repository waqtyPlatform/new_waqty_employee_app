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
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return BookingDetailsResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<BookingDetailsResponseModel> updateBookingStatus({
    required String uuid,
    required String status,
  }) async {
    final response = await apiConsumer.patch(
      BookingDetailsApiEndPoints.updateBookingStatus(uuid),
      {'status': status},
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return BookingDetailsResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<ServicesWithPricesResponseModel> getServicesWithPrices(
    int page,
  ) async {
    final response = await apiConsumer.get(
      BookingDetailsApiEndPoints.getServicesWithPrices(page),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return ServicesWithPricesResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
