import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/address/controller/address_controller.dart';
import 'package:opulencia/features/auth/controller/auth_controller.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/features/home/controller/home_controller.dart';
import 'package:opulencia/features/orders/controller/order_controller.dart';
import 'package:opulencia/lang/delegates/localizations_delegate.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/boxes/boxes.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/widgets/my_header.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'package:badges/badges.dart' as badges;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  showGreet() async {
    print('1');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('is_first_time') == null ||
        prefs.getBool('is_first_time')! == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWelcomeDialog();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initial data fetch
    showGreet();
    fetchData();
    // Show welcome dialog
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data whenever dependencies change, such as when the widget is re-entered
    fetchData();
  }

  void fetchData() {
    ref.read(authControllerProvider).getUserProfile(context: context);
    ref.read(homeControllerProvider).recentOrders(context: context);
    ref.read(homeControllerProvider).getTrendingFrames(context: context);
    ref.read(homeControllerProvider).getBanner(context: context);
    ref.read(homeControllerProvider).getNewInMarketFrames(context: context);
    ref.read(homeControllerProvider).getPrivacyPolicy(context: context);
    ref.read(homeControllerProvider).getRefundPolicy(context: context);
    ref.read(homeControllerProvider).getTermsAndCondtions(context: context);
    ref.read(orderControllerProvider).getOrderHistory(context: context);
    ref.read(catControllerProvider).getFramesByCat(context: context);
    ref.read(catControllerProvider).getPrices(context: context);
    ref.read(addressControllerProvider).getUserAddress(context: context);
    setState(() {});
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Welcome to Opulencia!',
            style: Styles.largeBoldText(context),
          ),
          content: Text(
            'We are glad to have you here :)',
            style: Styles.mediumText(context),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setBool('is_first_time', false);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var authData = ref.watch(authControllerProvider);
    var homeData = ref.watch(homeControllerProvider);
    final catData = ref.watch(catControllerProvider);
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HEY,',
                            style: Styles.mediumBoldText(context).copyWith(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context)
                                    .canvasColor
                                    .withOpacity(0.5)),
                          ),
                          Text(
                            authData.userData?.firstName?.toUpperCase() ?? '',
                            style: Styles.largeBoldText(context).copyWith(
                                fontWeight: FontWeight.w500,
                                height: 0.5,
                                fontSize: 40),
                          ),
                        ],
                      ),
                      badges.Badge(
                        position: badges.BadgePosition.topEnd(end: 1, top: -1),
                        showBadge: orderBox.length > 0,
                        badgeContent: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            orderBox.length.toString(),
                            style: Styles.smallBoldText(context),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            context.go('/${Routes.bottomNav}/${Routes.cart}');
                          },
                          icon: Image.asset(
                            'assets/icons/cart.png',
                            color: Theme.of(context).canvasColor,
                            height: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                  homeData.bannerList == null
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100.w,
                            height: 18.h,
                            color: Colors.white,
                          ),
                        )
                      : homeData.bannerList!.isEmpty
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 100.w,
                                height: 18.h,
                                color: Colors.white,
                              ),
                            )
                          : CarouselSlider.builder(
                              itemCount: homeData.bannerList!.length,
                              itemBuilder: (context, index, realIndex) {
                                return Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            homeData.bannerList![index].banner,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 100.w,
                                            height: 18.h,
                                            color: Colors.white,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        width: 100.w,
                                        height: 18.h,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              options: CarouselOptions(
                                viewportFraction: 1.0,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.easeInOut,
                                pauseAutoPlayOnTouch: true,
                                enlargeCenterPage: true,
                              ),
                            ),
                ],
              ),
            ),
            homeData.recentOrderList == null ||
                    homeData.recentOrderList!.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MyHeader(
                      text: 'Order Again',
                      onViewAllPressed: () {
                        catData.selectedCommonTitle = "Order Again";
                        context.go(
                            "/${Routes.bottomNav}/${Routes.myAllProducts}",
                            extra: homeData.recentOrderList);
                      },
                    ),
                  ),
            homeData.recentOrderList == null ||
                    homeData.recentOrderList!.isEmpty
                ? const SizedBox()
                : GridView.builder(
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeData.recentOrderList!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      var frames = homeData.recentOrderList![index];
                      return InkWell(
                        onTap: () {
                          context.go(
                              '/${Routes.bottomNav}/${Routes.commonProductDetail}',
                              extra: frames);
                        },
                        child: Container(
                          width: 30.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: frames.images![0].images!,
                                  width: 100.w,
                                  height: 100.h,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 100.w,
                                      height: 100.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7)
                                        ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      frames.frame!,
                                      maxLines: 2,
                                      style: Styles.mediumBoldText(context)
                                          .copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: MyHeader(
                  onViewAllPressed: () {
                    catData.selectedCommonTitle =
                        lang.translate(Strings.newInMarket);
                    context.go("/${Routes.bottomNav}/${Routes.myAllProducts}",
                        extra: homeData.newInMarketList);
                  },
                  text: lang.translate(Strings.newInMarket),
                )),
            GridView.builder(
              padding: const EdgeInsets.all(15),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: homeData.newInMarketList!.length >= 3
                  ? 3
                  : homeData.newInMarketList!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
              itemBuilder: (context, index) {
                var frames = homeData.newInMarketList![index];
                return InkWell(
                  onTap: () {
                    context.go(
                      '/${Routes.bottomNav}/${Routes.commonProductDetail}',
                      extra: frames,
                    );
                  },
                  child: Container(
                    width: 30.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: frames.images![0].images!,
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 100.w,
                                height: 100.h,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7)
                                  ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                frames.frame!,
                                maxLines: 2,
                                style: Styles.mediumBoldText(context).copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
