import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/cart/controller/cart_controller.dart';
import 'package:opulencia/features/cart/model/order_model.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/features/category/model/price_model.dart';
import 'package:opulencia/lang/delegates/localizations_delegate.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/boxes/boxes.dart';
import 'package:opulencia/utils/strings/icon_strings.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  bool isLiked = false;
  bool isCollapsed = false;

  List<Color> frameColors = [
    Colors.black,
    Colors.red,
    Colors.white,
  ];

  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;
  int itemQty = 1;
  String? selectedPriceId;

  bool isBorderedSelected = true;

  @override
  Widget build(BuildContext context) {
    final catData = ref.watch(catControllerProvider);
    final cartData = ref.watch(cartControllerProvider);
    // var frameData = catData
    //     .catList![catData.selectedCatIndex!]
    //     .subcategories[catData.selectedSubCatIndex!]
    //     .frames[catData.selectedFrameIndex!];
    var frameData = catData.isViewAll
        ? catData.allProducList![catData.selectedFrameIndex!]
        : catData
            .catList![catData.selectedCatIndex!]
            .subcategories[catData.selectedSubCatIndex!]
            .frames[catData.selectedFrameIndex!];
    var lang = AppLocalizations.of(context)!;
    List<PriceDetails> type1Prices =
        catData.priceList!.where((price) => price.type == '1').toList();
    List<PriceDetails> type0Prices =
        catData.priceList!.where((price) => price.type == '0').toList();
    var subCat = catData.catList![catData.selectedCatIndex!].subcategories;
    var sub = subCat[catData.selectedSubCatIndex!];
    return SafeArea(
      top: false,
      child: Scaffold(
          // extendBodyBehindAppBar: true,
          appBar: myAppBar(
              context: context,
              title: "",
              foregroundColor: Theme.of(context).canvasColor,
              action: [
                IconButton(
                    onPressed: () {
                      if (catData.wishList.contains(frameData)) {
                        catData.wishList.remove(frameData);
                      } else {
                        catData.wishList.add(frameData);
                      }
                      isLiked = !isLiked;
                      setState(() {});
                    },
                    icon: Icon(catData.wishList.contains(frameData)
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart)),
                IconButton(
                    onPressed: () {
                      context.go(
                          '/${Routes.bottomNav}/${Routes.category}/${Routes.subCategory}/${Routes.allProducts}/${Routes.productDetail}/${Routes.cart}');
                    },
                    icon: badges.Badge(
                      showBadge: orderBox.length > 0 ? true : false,
                      badgeContent: Text(
                        orderBox.length.toString(),
                        style: Styles.smallBoldText(context),
                      ),
                      child: const Icon(CupertinoIcons.cart),
                    ))
              ]),
          body: SingleChildScrollView(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: frameData.images!.first.images!,
                  width: 100.w,
                  height: 50.h,
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Column(
                  children: [
                    const Gap(7),
                    Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          frameData.frame!,
                                          style: Styles.mediumBoldText(context)
                                              .copyWith(fontSize: 18),
                                        ),
                                        SizedBox(
                                          width: 100.w - 30,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${isBorderedSelected ? type1Prices[selectedSizeIndex].endPrice : type0Prices[selectedSizeIndex].endPrice} ${Strings.currency}",
                                                style: Styles.mediumBoldText(
                                                        context)
                                                    .copyWith(
                                                        color: Colors.green,
                                                        fontSize: 18),
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      isBorderedSelected = true;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6,
                                                          vertical: 0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: isBorderedSelected
                                                                  ? Styles
                                                                      .orangeColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .canvasColor
                                                                      .withOpacity(
                                                                          0.3))),
                                                      child: Text(
                                                        'Bordered',
                                                        style: Styles.smallText(context).copyWith(
                                                            color: isBorderedSelected
                                                                ? Theme.of(
                                                                        context)
                                                                    .canvasColor
                                                                : Theme.of(
                                                                        context)
                                                                    .canvasColor
                                                                    .withOpacity(
                                                                        0.3)),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      isBorderedSelected =
                                                          false;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6,
                                                          vertical: 0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: isBorderedSelected
                                                                  ? Theme.of(
                                                                          context)
                                                                      .canvasColor
                                                                      .withOpacity(
                                                                          0.3)
                                                                  : Styles
                                                                      .orangeColor)),
                                                      child: Text(
                                                        'Borderless',
                                                        style: Styles.smallText(context).copyWith(
                                                            color: isBorderedSelected
                                                                ? Theme.of(
                                                                        context)
                                                                    .canvasColor
                                                                    .withOpacity(
                                                                        0.3)
                                                                : Theme.of(
                                                                        context)
                                                                    .canvasColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        RatingBar.builder(
                                          initialRating: 3,
                                          minRating: 1,
                                          itemSize: 12,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Styles.primary),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (itemQty > 0) {
                                              itemQty--;
                                              setState(() {});
                                            }
                                          },
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 8),

                                        SizedBox(
                                          width: 25,
                                          height: 22,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              itemQty.toString(),
                                              style: Styles.mediumText(context)
                                                  .copyWith(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Increment button
                                        InkWell(
                                          onTap: () {
                                            itemQty++;
                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .canvasColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang.translate(Strings.frameColor),
                                        style: Styles.mediumBoldText(context),
                                      ),
                                      SizedBox(
                                        width: 100.w,
                                        height: 40,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) {
                                            return const Gap(10);
                                          },
                                          itemCount: frameColors.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                selectedColorIndex = index;
                                                setState(() {});
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          spreadRadius:
                                                              selectedColorIndex ==
                                                                      index
                                                                  ? 1
                                                                  : 0,
                                                          blurRadius:
                                                              selectedColorIndex ==
                                                                      index
                                                                  ? 6
                                                                  : 0,
                                                          color:
                                                              frameColors[index]
                                                                  .withOpacity(
                                                                      0.4))
                                                    ],
                                                    border: Border.all(
                                                        width:
                                                            selectedColorIndex ==
                                                                    index
                                                                ? 2
                                                                : 0,
                                                        color: Theme.of(context)
                                                            .canvasColor),
                                                    shape: BoxShape.circle,
                                                    color: frameColors[index]),
                                                child: selectedColorIndex ==
                                                        index
                                                    ? Icon(
                                                        Icons.check,
                                                        size: 15,
                                                        color:
                                                            Styles.orangeColor,
                                                      )
                                                    : const SizedBox(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(10),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .canvasColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang.translate(Strings.size),
                                        style: Styles.mediumBoldText(context),
                                      ),
                                      const Gap(4),
                                      SizedBox(
                                        width: 100.w,
                                        height: 30,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) {
                                            return const Gap(10);
                                          },
                                          itemCount: isBorderedSelected
                                              ? type1Prices.length
                                              : type0Prices.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                selectedPriceId =
                                                    isBorderedSelected
                                                        ? type1Prices[index].id
                                                        : type0Prices[index].id;
                                                selectedSizeIndex = index;
                                                setState(() {});
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        width: selectedPriceId ==
                                                                null
                                                            ? 0.2
                                                            : selectedSizeIndex ==
                                                                    index
                                                                ? 2
                                                                : 0.2,
                                                        color:
                                                            Styles.orangeColor),
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor),
                                                child: Text(
                                                  isBorderedSelected
                                                      ? type1Prices[index].size
                                                      : type0Prices[index].size,
                                                  style:
                                                      Styles.mediumText(context)
                                                          .copyWith(
                                                              fontSize: 14),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(10),
                                Text(
                                  lang.translate(Strings.description),
                                  style: Styles.mediumBoldText(context),
                                ),
                                const Gap(10),
                                Text(
                                  frameData.description!,
                                  maxLines: 30,
                                  style: Styles.mediumText(context).copyWith(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .canvasColor
                                          .withOpacity(1)),
                                ),
                                const Gap(15),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Rating & Reviews (${frameData.reviews!.length})",
                                    style: Styles.mediumBoldText(context),
                                  ),
                                ),
                                const Gap(5),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 2)),
                                  child: RatingSummary(
                                    // labelStyle:
                                    //     const TextStyle(color: Colors.black),
                                    averageStyle: Styles.mediumBoldText(context)
                                        .copyWith(fontSize: 40),
                                    labelCounterOneStarsStyle:
                                        Styles.mediumText(context)
                                            .copyWith(fontSize: 14),
                                    labelCounterTwoStarsStyle:
                                        Styles.mediumText(context)
                                            .copyWith(fontSize: 14),
                                    labelCounterThreeStarsStyle:
                                        Styles.mediumText(context)
                                            .copyWith(fontSize: 14),
                                    labelCounterFourStarsStyle:
                                        Styles.mediumText(context)
                                            .copyWith(fontSize: 14),
                                    labelCounterFiveStarsStyle:
                                        Styles.mediumText(context)
                                            .copyWith(fontSize: 14),
                                    counter: frameData.reviews!.length,
                                    average: frameData.overallRating!
                                        .round()
                                        .toDouble(),
                                    showAverage: true,
                                    counterFiveStars: int.parse(
                                        frameData.ratingSummary![4].count!),
                                    counterFourStars: int.parse(
                                        frameData.ratingSummary![3].count!),
                                    counterThreeStars: int.parse(
                                        frameData.ratingSummary![2].count!),
                                    counterTwoStars: int.parse(
                                        frameData.ratingSummary![1].count!),
                                    counterOneStars: int.parse(
                                        frameData.ratingSummary![0].count!),
                                  ),
                                ),
                                const Gap(5),
                                const Gap(15),
                                ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return const Gap(20);
                                    },
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: frameData.reviews!.length,
                                    itemBuilder: (context, index) {
                                      var review = frameData.reviews![index];
                                      return Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                  color: Theme.of(context)
                                                      .canvasColor
                                                      .withOpacity(0.1))
                                            ]),
                                        width: 100.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    Strings.dummyProfile,
                                                    height: 20,
                                                    width: 20,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const Gap(5),
                                                Text(
                                                  "${review.firstName} ${review.lastName}",
                                                  style: Styles.mediumBoldText(
                                                          context)
                                                      .copyWith(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            const Gap(3),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                myRatings(
                                                    initialRating: double.parse(
                                                        review.rating!)),
                                                Opacity(
                                                  opacity: 0.5,
                                                  child: Text(
                                                    catData
                                                        .getFormattedUpdatedAt(
                                                            review.updatedAt!),
                                                    style: Styles.smallText(
                                                            context)
                                                        .copyWith(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Gap(5),
                                            Text(
                                              review.review!,
                                              maxLines: 4,
                                              style: Styles.smallText(context),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Suggested Frames',
                          style: Styles.mediumBoldText(context).copyWith(
                              color: Theme.of(context)
                                  .canvasColor
                                  .withOpacity(0.6),
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 140,
                      child: Row(
                        children: [
                          ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            itemCount: sub.frames.length,
                            separatorBuilder: (context, index) {
                              return Gap(2.w);
                            },
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var frames = sub.frames[index];
                              return frameData.id == frames.id
                                  ? const SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        catData.selectedFrameIndex = index;
                                        catData.selectedSubCatName =
                                            sub.subcategory;
                                        context.go(
                                          '/${Routes.bottomNav}/${Routes.category}/${Routes.subCategory}/${Routes.productDetail}',
                                        );
                                      },
                                      child: Container(
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          // color: _randomColor().withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    frames.images![0].images!,
                                                width: 100.w,
                                                height: 100.h,
                                                fit: BoxFit.contain,
                                                placeholder: (context, url) =>
                                                    Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    width: 100.w,
                                                    height: 100.h,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                            .withOpacity(0.7)
                                                      ])),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  // Text(
                                                  //   "\$${frames.prices[0].price}${Strings.currency}",
                                                  //   maxLines: 1,
                                                  //   style: Styles.mediumBoldText(context)
                                                  //       .copyWith(
                                                  //           color: Colors.yellow,
                                                  //           fontWeight: FontWeight.w800,
                                                  //           fontSize: 10,
                                                  //           height: 0.6),
                                                  // ),
                                                  Text(
                                                    frames.frame!,
                                                    maxLines: 2,
                                                    style:
                                                        Styles.mediumBoldText(
                                                                context)
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
                        ],
                      ),
                    ),
                    const Gap(100)
                  ],
                )
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                // color: Colors.red,
                // color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyCustomButton(
                      backgroundColor: Colors.white,
                      foregroundColor: Styles.primary,
                      width: 35.w,
                      label: lang.translate(Strings.addToCart),
                      onPressed: () {
                        if (selectedPriceId != null) {
                          final newOrder = OrderModel(
                            image: frameData.images![0].images.toString(),
                            isBordered: isBorderedSelected,
                            name: frameData.frame!,
                            selectedSize: isBorderedSelected
                                ? type1Prices[selectedSizeIndex].size
                                : type0Prices[selectedSizeIndex].size,
                            price: isBorderedSelected
                                ? type1Prices[selectedSizeIndex].endPrice
                                : type0Prices[selectedSizeIndex].endPrice,
                            frameId: frameData.id!,
                            priceId: selectedPriceId!,
                            frameColor: selectedColorIndex == 0
                                ? "Black"
                                : selectedColorIndex == 1
                                    ? "Red"
                                    : "White",
                            quantity: itemQty,
                          );

                          bool itemExists = false;

                          for (var order in orderBox.values) {
                            if (order.isBordered == newOrder.isBordered &&
                                order.name == newOrder.name &&
                                order.selectedSize == newOrder.selectedSize &&
                                order.price == newOrder.price &&
                                order.frameId == newOrder.frameId &&
                                order.priceId == newOrder.priceId &&
                                order.frameColor == newOrder.frameColor) {
                              order.quantity += itemQty;
                              itemExists = true;
                              break;
                            }
                          }

                          if (!itemExists) {
                            cartData.addToCart(order: newOrder);
                          }

                          setState(() {});
                        } else {
                          MyToast.failToast('Select Size', context);
                        }
                      },
                    ),
                    MyCustomButton(
                      icon: Image.asset(
                        IconStrings.shopBag,
                        height: 20,
                        color: Colors.white,
                      ),
                      width: 58.w,
                      label: lang.translate(Strings.orderNow),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget myRatings(
      {double initialRating = 0.0,
      Color? unratedColor,
      bool tapOnlyMode = false,
      bool ignoreGestures = false}) {
    return RatingBar.builder(
      initialRating: initialRating,
      minRating: 1,
      itemSize: 14,
      direction: Axis.horizontal,
      allowHalfRating: true,
      glow: true,
      ignoreGestures: ignoreGestures,
      unratedColor: unratedColor,
      wrapAlignment: WrapAlignment.end,
      itemCount: 5,
      tapOnlyMode: tapOnlyMode,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
