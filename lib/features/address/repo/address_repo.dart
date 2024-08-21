import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/address/model/address_model.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final addressRepositryProvider = Provider((ref) => AddressRepo());

class AddressRepo {
  static final Dio _dio = Dio();

  // ******************** ADD ADDRESS ***************************
  Future<void> addAddress(
      {required String title,
      required String province,
      required String city,
      required String address,
      required String landmark,
      required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/user-add-address';
      final formData = FormData.fromMap({
        'title': title,
        'province': province,
        'city': city,
        'address': address,
        'landmark': landmark,
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

// ******************** GET USER ADDRESS ***************************
  Future<AddressModel?> getUserAddress({required BuildContext context}) async {
    try {
      String url = '${Strings.baseUrl}/user-get-address';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('auth_token')!;
      Map<String, dynamic> header = {
        'auth-token': authToken,
      };
      final Response response =
          await _dio.get(url, options: Options(headers: header));

      if (response.statusCode == 200) {
        print(response.data);
        if (response.data["status"].toString() == "1") {
          var addressData = AddressModel.fromJson(response.data);
          // ignore: use_build_context_synchronously
          return addressData;
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
}
