import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/category/model/sub_product_model.dart';
import 'package:opulencia/features/home/model/banner_model.dart';
import 'package:opulencia/features/home/model/common_model.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final homeRepositryProvider = Provider((ref) => HomeRepo());

class HomeRepo {
  static final Dio _dio = Dio();

// ******************** GET TRENDING FRAMES ***************************
  Future<SubProductModel> getTrendingFrames(
      {required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/get-trending-frames';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));
      SubProductModel? data;
      if (response.statusCode == 200) {
        print("Trending Data: ${response.data}");
        if (response.data["status"].toString() == "1") {
          data = SubProductModel.fromJson(response.data);
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
      print(error);
      // ignore: use_build_context_synchronously
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** GET NEW IN THE MARKET FRAMES ***************************
  Future<SubProductModel> getNewInMarketFrames(
      {required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/new-in-market';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));
      SubProductModel? data;
      if (response.statusCode == 200) {
        print("Trending Data: ${response.data}");
        if (response.data["status"].toString() == "1") {
          data = SubProductModel.fromJson(response.data);
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
      print(error);
      // ignore: use_build_context_synchronously
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** GET RECENT ORDERS ***************************
  Future<SubProductModel> recentOrders({required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/recent-orders';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));
      SubProductModel? data;
      if (response.statusCode == 200) {
        print("Trending Data: ${response.data}");
        if (response.data["status"].toString() == "1") {
          data = SubProductModel.fromJson(response.data);
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
      print(error);
      // ignore: use_build_context_synchronously
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** SEARCH FRAMES ***************************
  Future<SubProductModel> searchFrames(
      {required String searchText, required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/search-frames';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      Map<String, dynamic> query = {
        'search_string': searchText,
      };
      final Response response = await _dio.get(url,
          options: Options(headers: header), queryParameters: query);
      SubProductModel? data;
      if (response.statusCode == 200) {
        print("Trending Data: ${response.data}");
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
      print(error);
      // ignore: use_build_context_synchronously
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** GET BANNER ***************************
  Future<BannerModel> getBanner({required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/get-banners';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));
      BannerModel? data;
      if (response.statusCode == 200) {
        print("Trending Data: ${response.data}");
        if (response.data["status"].toString() == "1") {
          data = BannerModel.fromJson(response.data);
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
      print(error);
      // ignore: use_build_context_synchronously
      MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** GET PRIVACY POLICY ***************************
  Future<CommonModel?> getPrivacy({required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/get-privacy-policy';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));

      if (response.statusCode == 200) {
        if (response.data["status"].toString() == "1") {
          return CommonModel.fromJson(response.data);
        } else {
          MyToast.infoToast(response.data['message'], context);
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 503) {
        MyToast.failToast(
            'Server is temporarily unavailable. Please try again later.',
            context);
      } else {
        MyToast.failToast(e.message.toString(), context);
      }
      rethrow;
    } catch (error) {
      // MyToast.failToast(
      //     'An unexpected error occurred. Please try again.', context);
      rethrow;
    }
    return null; // Return null if the request was unsuccessful
  }

// ******************** GET REFUND POLICY ***************************
  Future<CommonModel?> getRefundPrivacy({required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/get-refund-policy';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));

      if (response.statusCode == 200) {
        if (response.data["status"].toString() == "1") {
          return CommonModel.fromJson(response.data);
        } else {
          MyToast.infoToast(response.data['message'], context);
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 503) {
        MyToast.failToast(
            'Server is temporarily unavailable. Please try again later.',
            context);
      } else {
        MyToast.failToast(e.message.toString(), context);
      }
      rethrow;
    } catch (error) {
      // MyToast.failToast(
      //     'An unexpected error occurred. Please try again.', context);
      rethrow;
    }
    return null; // Return null if the request was unsuccessful
  }

// ******************** GET TERMS AND CONDITIONS ***************************
  Future<CommonModel?> getTermsAndConditions(
      {required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/get-terms-and-conditions';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));

      if (response.statusCode == 200) {
        if (response.data["status"].toString() == "1") {
          return CommonModel.fromJson(response.data);
        } else {
          MyToast.infoToast(response.data['message'], context);
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (error) {
      rethrow;
    }
    return null; // Return null if the request was unsuccessful
  }
}
