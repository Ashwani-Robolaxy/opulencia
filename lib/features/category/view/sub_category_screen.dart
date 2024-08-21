import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_empty_message.dart';
import 'package:opulencia/utils/widgets/my_header.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class SubCategoryScreen extends ConsumerStatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubCategoryScreenState();
}

class _SubCategoryScreenState extends ConsumerState<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final catData = ref.watch(catControllerProvider);
    var subCat = catData.catList![catData.selectedCatIndex!].subcategories;
    return Scaffold(
      appBar: myAppBar(context: context, title: catData.selectedCatName ?? ""),
      body: subCat.isEmpty
          ? const EmptyStateMessage(
              message: "No frame found!",
              animationAsset: "assets/lottie/sad.json")
          : ListView.builder(
              itemCount: subCat.length,
              itemBuilder: (context, index1) {
                var sub = subCat[index1];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MyHeader(
                        text: sub.subcategory,
                        onViewAllPressed: () async {
                          catData.selectedSubCatId = sub.id.toString();
                          catData.selectedSubCatIndex = index1;
                          catData.selectedSubCatName = sub.subcategory;
                          // ignore: use_build_context_synchronously
                          context.go(
                              '/${Routes.bottomNav}/${Routes.category}/${Routes.subCategory}/${Routes.allProducts}');
                        },
                      ),
                    ),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        itemCount: sub.frames.length,
                        separatorBuilder: (context, index) {
                          return Gap(2.w);
                        },
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var frames = sub.frames[index];
                          return InkWell(
                            onTap: () {
                              catData.selectedSubCatIndex = index1;
                              catData.selectedFrameIndex = index;
                              catData.selectedSubCatName = sub.subcategory;
                              context.go(
                                '/${Routes.bottomNav}/${Routes.category}/${Routes.subCategory}/${Routes.productDetail}',
                              );
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                    ),
                  ],
                );
              }),
    );
  }
}
