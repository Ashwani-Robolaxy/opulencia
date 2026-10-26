import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';
import 'package:opulencia/features/auth/model/login_model.dart';
import 'package:opulencia/features/auth/model/user_model.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositryProvider = Provider((ref) => AuthRepo());

class AuthRepo {
  static final Dio _dio = Dio();

// ******************** COMMON DIO ERROR HANDLER ***************************
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

    // Show a single toast for any DioException
    MyToast.failToast(message, context);
  }

// ******************** REGISTER ***************************
  Future<void> register({
    required String phone,
    required BuildContext context,
  }) async {
    final String registerUrl = '${Strings.baseUrl}/register-phone';

    try {
      final formData = FormData.fromMap({'phone': phone});
      final Response response = await _dio.post(registerUrl, data: formData);

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        context.go(
          '/${Routes.langSelection}/${Routes.authOption}/${Routes.otpVerify}',
        );
        // ignore: use_build_context_synchronously
        MyToast.infoToast(
          response.data['details'].toString(),
          context,
        );
      } else {
        // Treat all non-200 here as DioException so we can handle them below
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } on DioException catch (dioError) {
      _handleDioError(dioError, context);
      rethrow;
    } catch (e) {
      // Any other exception (parsing, runtime, etc.)
      // ignore: use_build_context_synchronously
      MyToast.failToast(e.toString(), context);
      rethrow;
    }
  }

// ******************** VERIFICATION ***************************
  Future<LoginModel> verifyPhone({required String phone, required String otp, required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/verify-phone-number';
      final formData = FormData.fromMap({
        'phone': phone,
        'otp': otp,
      });
      // Obtain shared preferences.

      final Response response = await _dio.post(
        url,
        data: formData,
      );
      LoginModel? loginData;
      if (response.statusCode == 200) {
        if (response.data["status"].toString() == "1") {
          loginData = LoginModel.fromJson(response.data);
        } else {
          MyToast.failToast(response.data['message'], context);
        }

        return loginData!;
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
      var logger = Logger();
      logger.w(error);
      // ignore: use_build_context_synchronously
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** GET USER PROFILE ***************************
  Future<UserModel> getUserProfile({required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/user-get-profile';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };

      final Response response = await _dio.get(url, options: Options(headers: header));
      UserModel? userData;
      if (response.statusCode == 200) {
        print(response.data);
        if (response.data["status"].toString() == "1") {
          userData = UserModel.fromJson(response.data);
          // ignore: use_build_context_synchronously
          context.go('/${Routes.bottomNav}');
        } else {
          // ignore: use_build_context_synchronously
          MyToast.infoToast(response.data['message'], context);
        }

        return userData!;
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
      MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

  // ******************** UPDATE PROFILE ***************************
  Future<void> updateProfile({required String firstName, required String lastName, required String email, required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/user-update-profile';
      final formData = FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      // Obtain shared preferences.
      final Response response = await _dio.post(url, data: formData, options: Options(headers: header));

      if (response.statusCode == 200) {
        if (response.data["status"].toString() == "1") {
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
    } on DioException catch (dioError) {
      _handleDioError(dioError, context);
      rethrow;
    } catch (error) {
      // ignore: use_build_context_synchronously
      MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }
}
