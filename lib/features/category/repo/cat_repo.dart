import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/category/model/frame_cat_model.dart';
import 'package:opulencia/features/category/model/price_model.dart';
import 'package:opulencia/features/category/model/sub_product_model.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final catRepositryProvider = Provider((ref) => CatRepo());

class CatRepo {
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

// ******************** GET FRAMES BY CATEGORY ***************************
  Future<FrameCatModel> getFramesByCategory({required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/get-frames-by-category';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response = await _dio.get(url, options: Options(headers: header));
      FrameCatModel? data;
      if (response.statusCode == 200) {
        print(response.data);
        if (response.data["status"].toString() == "1") {
          data = FrameCatModel.fromJson(response.data);
        } else {
          // ignore: use_build_context_synchronously
          MyToast.infoToast(response.data['message'], context);
        }

        return data!;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    }on DioException catch (dioError) {
      _handleDioError(dioError, context);
      rethrow;
    } catch (error) {
      // ignore: use_build_context_synchronously
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** GET PRICES ***************************
  Future<PriceModel> getPrices({required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/get-frame-prices';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response = await _dio.get(url, options: Options(headers: header));
      PriceModel? data;
      if (response.statusCode == 200) {
        print("Prices: ${response.data}");
        if (response.data["status"].toString() == "1") {
          data = PriceModel.fromJson(response.data);
        } else {
          // ignore: use_build_context_synchronously
          MyToast.infoToast(response.data['message'], context);
        }

        return data!;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    }on DioException catch (dioError) {
      _handleDioError(dioError, context);
      rethrow;
    }  catch (error) {
      // ignore: use_build_context_synchronously
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** GET SUB CAT PRODUCTS ***************************
  Future<SubProductModel> getSubProducts({required BuildContext context, required String subCatId}) async {
    try {
      String url = '${Strings.baseUrl}/get-frames-by-subcategory';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };

      Map<String, dynamic> params = {
        'subcategory_id': subCatId,
      };
      final Response response = await _dio.get(url, options: Options(headers: header), queryParameters: params);
      SubProductModel? data;
      if (response.statusCode == 200) {
        print(response.data);
        if (response.data["status"].toString() == "1") {
          data = SubProductModel.fromJson(response.data);
        } else {
          // ignore: use_build_context_synchronously
          // MyToast.infoToast(response.data['message'], context);
        }

        return data!;
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
}
