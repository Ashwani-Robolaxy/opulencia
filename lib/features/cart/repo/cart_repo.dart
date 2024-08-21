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

// ******************** MAKE ORDER ***************************
  Future<void> makeOrder({
    required String addressId,
    required String totalPrice,
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
        totalPrice: totalPrice,
        products: makeorderDetails,
      ).toJson();

      final Response response =
          await _dio.post(url, data: order, options: Options(headers: header));
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data['status'].toString() == "1") {
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
      // MyToast.failToast(error.toString(), context);
      rethrow;
    }
  }
// }
}
