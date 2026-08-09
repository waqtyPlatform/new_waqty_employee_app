import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/data/models/my_booking_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/data/services/my_booking_api_end_points.dart';

class MyBookingService {
  ApiConsumer apiConsumer;

  MyBookingService({required this.apiConsumer});

  Future<MyBookingResponseModel> getMyBookings({
    required String tab,
    required String bookingDate,
    required int page,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      MyBookingApiEndPoints.getMyBookings(
        tab: tab,
        bookingDate: bookingDate,
        page: page,
      ),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
        ConstantKeys.acceptLanguage: languageCode,
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == StatusCode.ok) {
      return MyBookingResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<void> cancelVisit({
    required String visitUuid,
    required String languageCode,
  }) async {
    final response = await apiConsumer.patch(
      MyBookingApiEndPoints.cancelVisit(visitUuid),
      null,
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
        ConstantKeys.acceptLanguage: languageCode,
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return;
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}

//mailto:ahmed.sameh@waqty-test.com
//123123123


