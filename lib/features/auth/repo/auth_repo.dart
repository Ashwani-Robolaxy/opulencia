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

// ******************** REGISTER ***************************
  Future<void> register(
      {required String phone, required BuildContext context}) async {
    try {
      String loginUrl = '${Strings.baseUrl}/register-phone';
      final formData = FormData.fromMap({
        'phone': phone,
      });
      final Response response = await _dio.post(
        loginUrl,
        data: formData,
      );
      print(response.data);
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        context.go(
            '/${Routes.langSelection}/${Routes.authOption}/${Routes.otpVerify}');

        // ignore: use_build_context_synchronously
        MyToast.infoToast(response.data['details'].toString(), context);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (error) {
      var logger = Logger(
        printer: PrettyPrinter(
            methodCount: 2, // Number of method calls to be displayed
            errorMethodCount:
                8, // Number of method calls if stacktrace is provided
            lineLength: 120, // Width of the output
            colors: true, // Colorful log messages
            printEmojis: true, // Print an emoji for each log message
            printTime: false // Should each log print contain a timestamp
            ),
      );
      var multilineLog = '''
$error
''';

      logger.w(multilineLog);
      print(error);
      // ignore: use_build_context_synchronously
      MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

// ******************** VERIFICATION ***************************
  Future<LoginModel> verifyPhone(
      {required String phone,
      required String otp,
      required BuildContext context}) async {
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
      
      final Response response =
          await _dio.get(url, options: Options(headers: header));
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
    } catch (error) {
      // ignore: use_build_context_synchronously
      MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }

  // ******************** UPDATE PROFILE ***************************
  Future<void> updateProfile(
      {required String firstName,
      required String lastName,
      required String email,
      required BuildContext context}) async {
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
      final Response response = await _dio.post(url,
          data: formData, options: Options(headers: header));

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
    } catch (error) {
      // ignore: use_build_context_synchronously
      MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }
}
