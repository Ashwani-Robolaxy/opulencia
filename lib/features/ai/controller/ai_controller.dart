import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/ai/model/ai_model.dart';
import 'package:opulencia/features/ai/repo/ai_repo.dart';
import 'package:opulencia/utils/toast/my_toast.dart';

// Provider to create and watch the AiController
final aiControllerProvider = Provider((ref) {
  final aiRepository = ref.watch(aiRepositoryProvider);
  return AiController(aiRepository: aiRepository, ref: ref);
});

class AiController {
  final AiRepo aiRepository;
  final ProviderRef ref;
  String? _enhancedImageUrl; // Field to store the enhanced image URL
  String? _recordId; // Field to store the enhanced image URL

  AiController({required this.aiRepository, required this.ref});

  // Getter for the enhanced image URL
  String? get enhancedImageUrl => _enhancedImageUrl;
  String? get recordId => _recordId;

  // **************** ↓↓ AI CONTROLLER FUNCTIONS HERE ↓↓ ***********************
  void resetEnhancedImageUrl() {
    _enhancedImageUrl = null;
    _recordId = null;
  }

  // Function to handle image enhancement
  Future<void> enhanceImage({
    required File image,
    required BuildContext context,
  }) async {
    try {
      AiModel? aiData =
          await aiRepository.enhanceImage(image: image, context: context);
      print(aiData);

      if (aiData != null) {
        // Assuming the enhanced image URL comes from aiData.output.tmpUrl
        _enhancedImageUrl = aiData.url;
        _recordId = aiData.recordId.toString();

        if (context.mounted) {
          MyToast.successToast("Image enhanced successfully!", context);
        }
      } else {
        if (context.mounted) {
          MyToast.failToast("Failed to enhance image", context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        print(e.toString());
        // MyToast.failToast(e.toString(), context);
      }
    }
  }
}
