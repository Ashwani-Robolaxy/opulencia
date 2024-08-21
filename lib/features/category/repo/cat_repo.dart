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

// ******************** GET FRAMES BY CATEGORY ***************************
  Future<FrameCatModel> getFramesByCategory(
      {required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/get-frames-by-category';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));
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
      final Response response =
          await _dio.get(url, options: Options(headers: header));
      PriceModel? data;
      if (response.statusCode == 200) {
        print(response.data);
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
    } catch (error) {
      // ignore: use_build_context_synchronously
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** GET SUB CAT PRODUCTS ***************************
  Future<SubProductModel> getSubProducts(
      {required BuildContext context, required String subCatId}) async {
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
      final Response response = await _dio.get(url,
          options: Options(headers: header), queryParameters: params);
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
    } catch (error) {
      // ignore: use_build_context_synchronously
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }
}
