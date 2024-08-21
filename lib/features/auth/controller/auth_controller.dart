import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/address/controller/address_controller.dart';
import 'package:opulencia/features/auth/model/login_model.dart';
import 'package:opulencia/features/auth/model/user_model.dart';
import 'package:opulencia/features/auth/repo/auth_repo.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/features/home/controller/home_controller.dart';
import 'package:opulencia/features/orders/controller/order_controller.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';

import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authControllerProvider = Provider((ref) {
  final authRepositry = ref.watch(authRepositryProvider);
  return AuthController(ref: ref, authRepositry: authRepositry);
});

class AuthController {
  final AuthRepo authRepositry;
  final ProviderRef ref;
  AuthController({required this.ref, required this.authRepositry});

  // UserDetailsModel? userData;

// ***************** VERIFY OTP ******************
  String? userOtp;
  defaultPinTheme(BuildContext context) {
    return PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Theme.of(context).canvasColor,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).canvasColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  focusedPinTheme(BuildContext context) {
    return PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Theme.of(context).canvasColor,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).canvasColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    ).copyDecorationWith(
      border: Border.all(color: Theme.of(context).canvasColor),
      borderRadius: BorderRadius.circular(8),
    );
  }

  submittedPinTheme(BuildContext context) {
    return PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Theme.of(context).canvasColor,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).canvasColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    ).copyWith(
      decoration: PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(
            fontSize: 20,
            color: Theme.of(context).canvasColor,
            fontWeight: FontWeight.w600),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).canvasColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ).decoration!.copyWith(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
    );
  }

  Future<void> fetchData(BuildContext context) async {
    var addData = ref.read(addressControllerProvider);
    final catData = ref.read(catControllerProvider);
    final homeData = ref.read(homeControllerProvider);
    final orderData = ref.read(orderControllerProvider);

    await Future.wait([
      homeData.recentOrders(context: context),
      homeData.getTrendingFrames(context: context),
      homeData.getBanner(context: context),
      homeData.getNewInMarketFrames(context: context),
      homeData.getPrivacyPolicy(context: context),
      homeData.getRefundPolicy(context: context),
      homeData.getTermsAndCondtions(context: context),
      orderData.getOrderHistory(context: context),
      catData.getFramesByCat(context: context),
      catData.getPrices(context: context),
      addData.getUserAddress(context: context),
      getUserProfile(context: context),
    ]);
  }

  LoginModel? loginData;

  Future verifyPhone(BuildContext context) async {
    if (userOtp != null || userOtp!.isEmpty || userOtp!.length != 4) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        EasyLoading.show(status: 'Logging in...');
        await authRepositry
            .verifyPhone(
          otp: userOtp!,
          phone: "+$countryCode${phoneController.text}",
          context: context,
        )
            .then((value) async {
          if (value.status.toString() == "1") {
            loginData = value;
            prefs.setString('auth_token', loginData!.details.authToken);
            prefs.setBool('is_first_time', true);
            phoneController.clear();

            // ignore: use_build_context_synchronously
            await fetchData(context).then(
              (value) {
                Future.delayed(Duration.zero, () {
                  // ignore: use_build_context_synchronously
                  context.go('/${Routes.bottomNav}');
                });
              },
            );

            EasyLoading.dismiss();
          } else {
            EasyLoading.dismiss();
          }
        });
      } catch (e) {
        EasyLoading.dismiss();
        // Handle any other errors
      }
    } else {
      EasyLoading.dismiss();
      MyToast.failToast('Enter OTP', context);
    } 
  }

// ************ LOGIN CONTROLLER ***********************
  TextEditingController phoneController = TextEditingController();
  String countryCode = "1";
  Future login(BuildContext context) async {
    if (phoneController.text.isNotEmpty) {
      try {
        EasyLoading.show(status: 'Logging in...');
        await authRepositry
            .register(
          phone: "+$countryCode${phoneController.text}",
          context: context,
        )
            .then((value) {
          EasyLoading.dismiss();
        });
      } catch (e) {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();

      // MyToast.failToast('Fields cannot be empty', context);
    }
  }

// ************ GET USER DATA ***********************
  UserDetails? userData;
  Future getUserProfile({required BuildContext context}) async {
    try {
      await authRepositry
          .getUserProfile(
        context: context,
      )
          .then((value) {
        userData = value.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
// ************ UPDATE USER PROFILE ***********************

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  enterData() {
    firstNameController.text = userData!.firstName!;
    lastNameController.text = userData!.lastName!;
    emailController.text = userData!.email!;
  }

  Future updateProfile({required BuildContext context}) async {
    try {
      EasyLoading.show(status: 'Updating Profile...');
      await authRepositry
          .updateProfile(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        context: context,
      )
          .then((value) async {
        await getUserProfile(context: context);
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        // ignore: use_build_context_synchronously
        Navigator.pop(context, {"refresh": "refreshed"});
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
}
