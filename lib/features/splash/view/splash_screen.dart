import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/address/controller/address_controller.dart';
import 'package:opulencia/features/auth/controller/auth_controller.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/features/home/controller/home_controller.dart';
import 'package:opulencia/features/orders/controller/order_controller.dart';
import 'package:opulencia/utils/strings/icon_strings.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define loading state provider
final loadingStateProvider = StateProvider<bool>((ref) => true);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late double _fontSize;

  Future<void> fetchData() async {
    var authData = ref.read(authControllerProvider);
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
      authData.getUserProfile(context: context),
    ]);
  }

  Future<void> checkPost() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('auth_token') == null) {
      Timer(const Duration(seconds: 4), () {
        if (mounted) {
          context.go('/${Routes.langSelection}');
        }
      });
    } else {
      fetchData().then(
        (value) {
          if (mounted) {
            ref.read(loadingStateProvider.notifier).state = false;
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkPost();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    _fontSize = screenWidth / 7;

    // Watch loading state
    final isLoading = ref.watch(loadingStateProvider);

    if (!isLoading) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          context.go('/${Routes.bottomNav}');
        }
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              IconStrings.appIcon,
              width: 80.w,
            ),
          ],
        ),
      ),
    );
  }
}
