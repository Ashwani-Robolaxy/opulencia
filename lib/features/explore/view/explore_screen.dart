import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/features/home/controller/home_controller.dart';
import 'package:opulencia/lang/delegates/localizations_delegate.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/widgets/my_header.dart';
import 'package:opulencia/utils/widgets/my_textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreScreenState();
}

List<String> categories = [
  'Paintings & Prints',
  'Photography',
  'Drawings & Illustration',
  'Digital Art',
  'Sculptures & Carvings',
  'Ceramics & Pottery',
  'Glass',
  'Jewelry',
  'Textile & Apparel',
  'Crafts & Other Art',
];

Color _randomColor() {
  final Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,
  );
}

double _randomWidth() {
  final Random random = Random();
  return random.nextDouble() * 100 + 50; // Generates width between 50 and 150
}

// Function to generate a random height
double _randomHeight() {
  final Random random = Random();
  return random.nextDouble() * 100 + 50; // Generates height between 50 and 150
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final catData = ref.watch(catControllerProvider);
    final homeData = ref.watch(homeControllerProvider);
    var lang = AppLocalizations.of(context)!;
    return Scaffold(
      // appBar: myAppBar(

      //     // automaticallyImplyLeading: false,
      //     context: context,
      //     title: "Explore"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Hero(
                tag: "search_tag",
                child: MyTextField(
                  onTap: () {
                    context.go("/${Routes.bottomNav}/${Routes.search}");
                  },
                  // enabled: false,
                  controller: TextEditingController(),
                  hintText: "Search",
                  prefixIconData: const Icon(Icons.search),
                  hasPrefix: true,
                ),
              ),
            ),
            const Gap(10),
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: MyHeader(
                  onViewAllPressed: () {
                    catData.selectedCommonTitle = "Trending Frames";
                    context.go("/${Routes.bottomNav}/${Routes.myAllProducts}",
                        extra: homeData.trendingList);
                  },
                  text: lang.translate(Strings.trendingFrames),
                )),
            GridView.builder(
              padding: const EdgeInsets.all(15),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: homeData.trendingList!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
              itemBuilder: (context, index) {
                var frames = homeData.trendingList![index];
                return InkWell(
                  onTap: () {
                    context.go(
                        '/${Routes.bottomNav}/${Routes.commonProductDetail}',
                        extra: frames);
                  },
                  child: Container(
                    width: 30.w,
                    decoration: BoxDecoration(
                      // color: _randomColor().withOpacity(0.4),
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
            const Gap(10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: MyHeader(
                  text: lang.translate(Strings.exploreByCategory),
                  onViewAllPressed: () {
                    context.go("/${Routes.bottomNav}/${Routes.category}");
                  },
                )),
            SizedBox(
              height: 100,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount:
                    catData.catList!.length > 3 ? 4 : catData.catList!.length,
                separatorBuilder: (context, index) {
                  return const Gap(10);
                },
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var cat = catData.catList![index];
                  return InkWell(
                    onTap: () {
                      catData.selectedCatIndex = index;
                      catData.selectedCatName = cat.category;
                      context.go("/${Routes.bottomNav}/${Routes.subCategory}");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _randomColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        cat.category,
                        style: Styles.mediumText(context),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Gap(10),
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
                        extra: frames);
                  },
                  child: Container(
                    width: 30.w,
                    decoration: BoxDecoration(
                      // color: _randomColor().withOpacity(0.4),
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
