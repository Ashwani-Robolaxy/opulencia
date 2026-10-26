import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/cart/model/make_order_model.dart';

import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cartRepositryProvider = Provider((ref) => CartRepo());

class CartRepo {
  static final Dio _dio = Dio();

  void _handleDioError(DioException dioError, BuildContext context) {
    final int? statusCode = dioError.response?.statusCode;
    String message;

    switch (statusCode) {
      case 400:
        message = 'Bad request. Please verify your input.';
        break;
      case 401:
        message = 'Unauthorized. Please check your credentials.';
        break;
      case 403:
        message = 'Forbidden. You don’t have permission to perform this action.';
        break;
      case 404:
        message = 'Endpoint not found. Please contact support.';
        break;
      case 409:
        message = 'Conflict detected. Resource already exists.';
        break;
      case 422:
        message = 'Validation failed. Make sure all fields are correct.';
        break;
      case 429:
        message = 'Too many attempts. Please wait and try again later.';
        break;
      case 500:
        message = 'Internal server error. Please try again later.';
        break;
      case 502:
        message = 'Bad gateway. There’s an issue connecting to the server.';
        break;
      case 503:
        message = 'Service unavailable. Please try again later.';
        break;
      case 504:
        message = 'Server timeout. Please check your connection.';
        break;
      default:
        if (statusCode != null) {
          // Attempt to read a server‐sent error description, or fallback
          final data = dioError.response?.data;
          if (data != null && data is Map<String, dynamic> && (data['error'] != null || data['message'] != null)) {
            message = data['error']?.toString() ?? data['message']!.toString();
          } else {
            message = 'Unexpected error (code $statusCode).';
          }
        } else {
          // No status code—likely a network issue or timeout
          message = 'Network error. Please check your internet connection.';
        }
    }
  }

// ******************** MAKE ORDER ***************************
  Future<Map<String, dynamic>?> makeOrder({
    required String addressId,
    required String totalPrice,
    String? nif,
    required List<Product> makeorderDetails,
    required BuildContext context,
  }) async {
    try {
      String url = '${Strings.baseUrl}/place-order';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      // Create the order
      final order = MakeOrderModel(
        addressId: addressId,
        nif: nif,
        totalPrice: totalPrice,
        products: makeorderDetails,
      ).toJson();

      final Response response = await _dio.post(url, data: order, options: Options(headers: header));
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data['status'].toString() == "1") {
          // ignore: use_build_context_synchronously
          MyToast.successToast(response.data['message'], context);
          // Return the response data to check for webview_url
          return response.data;
        } else {
          // ignore: use_build_context_synchronously
          MyToast.failToast(response.data['message'], context);
          return null;
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } on DioException catch (dioError) {
      _handleDioError(dioError, context);
      rethrow;
    } catch (error) {
      // ignore: use_build_context_synchronously
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }
// }
}
