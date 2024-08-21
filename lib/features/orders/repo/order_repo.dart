import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/orders/model/custom_order_model.dart';
import 'package:opulencia/features/orders/model/order_history_model.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final orderRepositryProvider = Provider((ref) => OrderRepo());

class OrderRepo {
  static final Dio _dio = Dio();

// ******************** GET ORDER HISTORY ***************************
  Future<OrderHistoryModel?> getOrderHistory(
      {required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/get-order-history';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));

      print(response.data);
      if (response.statusCode == 200) {
        if (response.data["status"].toString() == "1") {
          var data = OrderHistoryModel.fromJson(response.data);
          // ignore: use_build_context_synchronously
          return data;
        } else {
          return null;
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** GET CUSTOM ORDER HISTORY ***************************
  Future<CustomOrderModel?> getCustomOrderHistory(
      {required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/get-custom-order-history';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));

      print(response.data);
      if (response.statusCode == 200) {
        if (response.data["status"].toString() == "1") {
          var data = CustomOrderModel.fromJson(response.data);
          // ignore: use_build_context_synchronously
          return data;
        } else {
          return null;
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** ADD REVIEW ***************************
  Future<void> addReview({
    required String productId,
    required int rating,
    required String review,
    required BuildContext context,
  }) async {
    try {
      String url = '${Strings.baseUrl}/add-review';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final formData = FormData.fromMap({
        'product_id': productId,
        'rating': rating,
        'review': review,
      });
      final Response response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: header),
      );

      print(response.data);
      if (response.statusCode == 200) {
        if (response.data["status"].toString() == "1") {
          context.go("/${Routes.bottomNav}");
          // ignore: use_build_context_synchronously
          MyToast.successToast(response.data['message'], context);
        } else {
          // ignore: use_build_context_synchronously
          MyToast.failToast(response.data['message'], context);
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }
}
