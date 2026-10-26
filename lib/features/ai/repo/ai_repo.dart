import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/ai/model/ai_model.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final aiRepositoryProvider = Provider((ref) => AiRepo());

class AiRepo {
  static final Dio _dio = Dio();

  // ******************** ENHANCE IMAGE ***************************
  Future<AiModel?> enhanceImage({
    required File image,
    required BuildContext context,
  }) async {
    try {
      String url = '${Strings.baseUrl}/claid-edit-image';
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
      });

      // Obtain shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('auth_token');

      if (authToken == null || authToken.isEmpty) {
        // Handle the case where the token is not available
        MyToast.failToast('Authorization token not found', context);
        return null;
      }

      Map<String, dynamic> header = {
        'auth-token': authToken,
      };

      // Make the request
      final Response response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: header),
      );
      print(response.data);

      if (response.statusCode == 200) {
        AiModel aiData = AiModel.fromJson(response.data);
        // Check if widget is still mounted before using context
        if (context.mounted) {
          MyToast.successToast("Success", context);
        }
        return aiData;
      } else {
        // Handle failed status
        if (context.mounted) {
          MyToast.failToast("Failed", context);
        }
        return null;
      }
    } catch (error) {
      if (context.mounted) {
        debugPrint(image.path);
        debugPrint(error.toString());
        MyToast.failToast(error.toString(), context);
      }
      rethrow;
    }
  }
}
