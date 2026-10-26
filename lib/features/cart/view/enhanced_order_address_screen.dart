import 'dart:io';
import 'dart:math';

import 'package:action_slider/action_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/address/controller/address_controller.dart';
import 'package:opulencia/features/address/view/add_address_screen.dart';
import 'package:opulencia/features/ai/controller/ai_controller.dart';
import 'package:opulencia/features/cart/controller/cart_controller.dart';
import 'package:opulencia/features/orders/controller/order_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_empty_message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:opulencia/utils/widgets/my_textfield.dart';
import 'package:opulencia/features/cart/view/order_webview_screen.dart';

class EnhancedOrderAddressScreen extends ConsumerStatefulWidget {
  String recordId;
  String sizeId;
  String frameType;
  String frameColor;

  EnhancedOrderAddressScreen({required this.recordId, required this.sizeId, required this.frameType, required this.frameColor, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnhancedOrderAddressScreenState();
}

class _EnhancedOrderAddressScreenState extends ConsumerState<EnhancedOrderAddressScreen> {
  final TextEditingController nifController = TextEditingController();

  @override
  void dispose() {
    nifController.dispose();
    super.dispose();
  }

  Color _randomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  int selectedIndex = 1;
  Future<void> _showDownloadDialog(BuildContext context) async {
    final aiData = ref.watch(aiControllerProvider);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Order Placed',
            style: Styles.largeBoldText(context),
          ),
          content: Text('Do you want to download the enhanced image?', maxLines: 3, style: Styles.mediumText(context)),
          actions: <Widget>[
            TextButton(
              child: const Text('Skip'),
              onPressed: () {
                aiData.resetEnhancedImageUrl();
                // Navigate to bottom nav
                context.go('/${Routes.bottomNav}');
              },
            ),
            TextButton(
              child: const Text('Download'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _downloadEnhancedImage(context).whenComplete(
                  () {
                    aiData.resetEnhancedImageUrl();
                  },
                ); // Download the image
                context.go('/${Routes.bottomNav}'); // Navigate to bottom nav
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadEnhancedImage(BuildContext context) async {
    String? enhancedImageUrl;
    final aiData = ref.watch(aiControllerProvider);
    enhancedImageUrl = aiData.enhancedImageUrl;
    if (enhancedImageUrl == null) return;

    // Request permission to write to external storage (needed for Android)
    if (await Permission.storage.request().isGranted) {
      try {
        Dio dio = Dio();
        // Get a temporary directory to download the image
        final Directory tempDir = await getTemporaryDirectory();
        const String fileName = 'enhanced_image.jpg';
        final String filePath = '${tempDir.path}/$fileName';

        // Download the image from the URL to the temporary directory
        await dio.download(enhancedImageUrl, filePath);

        // Save the downloaded image to the gallery
        await GallerySaver.saveImage(filePath, albumName: 'EnhancedImages');

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to gallery')),
        );
      } catch (e) {
        // Handle download error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download image: $e}')),
        );
      }
    } else {
      // If permission is not granted, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission to access storage is denied')),
      );
    }
  }
  // ... existing code ...

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartControllerProvider);
    final addData = ref.watch(addressControllerProvider);
    final orderData = ref.watch(orderControllerProvider);
    return Scaffold(
        appBar: myAppBar(context: context, title: "Select Address"),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: addData.addressList.isEmpty
              ? const EmptyStateMessage(
                  message: "No Address Found!",
                  animationAsset: "assets/lottie/sad.json",
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const Gap(10);
                          },
                          itemCount: addData.addressList.length,
                          itemBuilder: (context, index) {
                            var address = addData.addressList[index];
                            return InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                cartData.selectedAddressId = address.id;
                                selectedIndex = index;
                                setState(() {});
                              },
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: selectedIndex == index || cartData.selectedAddressId == address.id ? Styles.primary : Colors.transparent),
                                        borderRadius: BorderRadius.circular(17)),
                                    child: Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [Colors.transparent, Styles.orangeColor]),
                                          border: BorderDirectional(start: BorderSide(width: 50, color: Styles.primary)),
                                          color: _randomColor().withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  address.title!,
                                                  style: Styles.mediumBoldText(context),
                                                ),
                                                Text(
                                                  "${address.province}\n${address.city}\n${address.address}\n${address.landmark}",
                                                  style: Styles.smallText(context),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                      address.title == "Home"
                                          ? addData.addressIcons[0]
                                          : address.title == "Work"
                                              ? addData.addressIcons[1]
                                              : address.title == "Hotel"
                                                  ? addData.addressIcons[2]
                                                  : addData.addressIcons[3],
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: Theme.of(context).canvasColor,
                                        )),
                                  )
                                ],
                              ),
                            );
                          }),
                      const Gap(20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddAddressScreen(),
                              )).then((value) {
                            if (value['refresh'] == "refreshed") {
                              setState(() {});
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100.w,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Styles.primary),
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: Styles.primary,
                                size: 20,
                              ),
                              Text(
                                'Add Address',
                                style: Styles.mediumBoldText(context).copyWith(color: Styles.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(20),
                      MyTextField(
                        controller: nifController,
                        hintText: "Enter NIF Number (Optional)",
                        hasTitle: true,
                        title: "NIF Number",
                      ),
                      const Gap(100), // Extra space for FAB
                    ],
                  ),
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: cartData.selectedAddressId == null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: ActionSlider.standard(
                  toggleColor: Styles.primary,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                  child: Text(
                    'Slide to place Order'.toUpperCase(),
                    style: Styles.mediumBoldText(context),
                  ),
                  action: (controller) async {
                    controller.loading(); // Starts loading animation
                    orderData
                        .createEnhancedOrder(
                      context: context,
                      addressId: cartData.selectedAddressId!,
                      frameColor: widget.frameColor,
                      frameType: widget.frameType,
                      recordId: widget.recordId,
                      sizeId: widget.sizeId,
                      nif: nifController.text.trim().isEmpty ? null : nifController.text.trim(),
                    )
                        .then((value) {
                      controller.success(); // Starts success animation
                      if (value != null && value['webview_url'] != null && value['webview_url'].toString().isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderWebviewScreen(
                              url: value['webview_url'].toString(),
                              title: 'Complete Payment',
                            ),
                          ),
                        );
                      } else {
                        // Show the dialog after order is placed if no payment needed
                        _showDownloadDialog(context);
                      }
                    }).catchError((error) {
                      controller.failure(); // Handle failure
                    });

                    // await Future.delayed(const Duration(seconds: 3));
                  },
                ),
              ));
  }
}
