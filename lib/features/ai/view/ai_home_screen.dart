import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'package:opulencia/features/ai/controller/ai_controller.dart'; // Import your AiController
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/icon_strings.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:image_compare_slider/image_compare_slider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:path_provider/path_provider.dart'; // Import for downloading
import 'package:permission_handler/permission_handler.dart'; // Import for permission handling

class AiHomeScreen extends ConsumerStatefulWidget {
  const AiHomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AiHomeScreenState();
}

class _AiHomeScreenState extends ConsumerState<AiHomeScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  String? _enhancedImageUrl;
  bool _isComparing = false; // Track compare mode

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _enhancedImageUrl = null; // Reset enhanced image
        _isComparing = false; // Reset compare mode
      });
    }
  }

  Future<void> _enhanceImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    final aiController = ref.read(aiControllerProvider);

    try {
      await aiController.enhanceImage(
        image: _selectedImage!,
        context: context,
      );

      setState(() {
       
        _enhancedImageUrl =
            aiController.enhancedImageUrl; // Store enhanced image URL
        _isLoading = false;

        // Once the enhanced image is ready, allow comparison
        if (_enhancedImageUrl != null) {
          _isComparing = true; // Enable comparison
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to download and save the enhanced image to the gallery
  Future<void> _downloadEnhancedImage() async {
    if (_enhancedImageUrl == null) return;

    // Request permission to write to external storage (needed for Android)
    if (await Permission.storage.request().isGranted) {
      try {
        Dio dio = Dio();
        // Get a temporary directory to download the image
        final Directory tempDir = await getTemporaryDirectory();
        const String fileName = 'enhanced_image.jpg';
        final String filePath = '${tempDir.path}/$fileName';

        // Download the image from the URL to the temporary directory
        await dio.download(_enhancedImageUrl!, filePath);

        // Save the downloaded image to the gallery
        await GallerySaver.saveImage(filePath, albumName: 'EnhancedImages');

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to gallery')),
        );
      } catch (e) {
        // Handle download error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download image')),
        );
      }
    } else {
      // If permission is not granted, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission to access storage is denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: "Upload and Enhance", action: [
        IconButton(
          onPressed: (_selectedImage != null && _enhancedImageUrl != null)
              ? () {
                  setState(() {
                    _isComparing = !_isComparing; // Toggle compare mode
                  });
                }
              : null, // Disable compare if no images are available
          icon: const Icon(Icons.compare),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isComparing &&
                _enhancedImageUrl != null &&
                _selectedImage != null)
              Expanded(
                child: ImageCompareSlider(
                  itemOne: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: 100.w,
                    height: 100.w,
                  ),
                  itemTwo: Image.network(
                    _enhancedImageUrl!,
                    fit: BoxFit.cover,
                    width: 100.w,
                    height: 100.w,
                  ),
                ),
              )
            else if (_enhancedImageUrl != null)
              Image.network(
                _enhancedImageUrl!,
                height: 100.w,
                width: 100.w,
                fit: BoxFit.cover,
              )
            else if (_selectedImage != null)
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(
                    _selectedImage!,
                    height: 100.w,
                    width: 100.w,
                    fit: BoxFit.cover,
                  ),
                  if (_isLoading)
                    Lottie.asset(
                      IconStrings.aiLottie,
                      width: 100.w,
                      height: 100.w,
                      fit: BoxFit.cover,
                    ),
                ],
              )
            else
              Container(
                height: 100.w,
                width: double.infinity,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 100, color: Colors.grey[700]),
              ),
            const Gap(30),
            !_isLoading
                ? MyCustomButton(
                    onPressed: _pickImage,
                    label: 'Select Image',
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            !_isLoading && _selectedImage != null && _enhancedImageUrl == null
                ? MyCustomButton(
                    onPressed: _isLoading ? () {} : _enhanceImage,
                    label: 'Enhance Image',
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            // _enhancedImageUrl != null
            //     ? MyCustomButton(
            //         onPressed: _downloadEnhancedImage,
            //         label: 'Download',
            //       )
            //     : const SizedBox(),

            _enhancedImageUrl != null
                ? MyCustomButton(
                    backgroundColor: Styles.orangeColor,
                    onPressed: () {
                      context.go(
                          '/${Routes.bottomNav}/${Routes.aiHome}/${Routes.postAi}');
                    },
                    label: 'Continue',
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
