import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_empty_message.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class AllProductsScreen extends ConsumerStatefulWidget {
  const AllProductsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllProductsScreenState();
}

class _AllProductsScreenState extends ConsumerState<AllProductsScreen> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    final catData = ref.read(catControllerProvider);
    catData.getSubCatProducts(context: context).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final catData = ref.watch(catControllerProvider);

    // Populate and reverse the index list
    List<int> reverseIndex =
        List.generate(catData.allProducList?.length ?? 0, (index) => index)
            .reversed
            .toList();

    return Scaffold(
      appBar:
          myAppBar(context: context, title: catData.selectedSubCatName ?? ""),
      body: catData.allProducList == null
          ? MasonryGridView.count(
              itemCount: 8, // Number of shimmer placeholders
              padding: const EdgeInsets.all(10),

              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,

              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          width: 100.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16, width: 100),
                              SizedBox(height: 8),
                              SizedBox(height: 16, width: 60),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : catData.allProducList!.isEmpty
              ? const EmptyStateMessage(
                  message: "No Product Found!",
                  animationAsset: "assets/lottie/sad.json")
              : GridView.builder(
                  itemCount: catData.allProducList!.length,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.74,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    var data = catData.allProducList![index];
                    var newIndex = reverseIndex[index];

                    return InkWell(
                      onTap: () {
                        catData.selectedSubCatId = data.subcategoryId;
                        catData.selectedFrameIndex = newIndex;
                        context.go(
                            '/${Routes.bottomNav}/${Routes.category}/${Routes.subCategory}/${Routes.allProducts}/${Routes.productDetail}');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).canvasColor.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: data.images![0].images!,
                                    height: 200,
                                    width: 100.w,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 100.w,
                                        height: 200,
                                        color: Colors.white,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      if (catData.wishList.contains(data)) {
                                        catData.wishList.remove(data);
                                      } else {
                                        catData.wishList.add(data);
                                      }
                                      isLiked = !isLiked;
                                      setState(() {});
                                      catData.wishList.removeAt(index);
                                      setState(() {});
                                    },
                                    icon: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        catData.wishList.contains(data)
                                            ? CupertinoIcons.heart_fill
                                            : CupertinoIcons.heart,
                                        color: catData.wishList.contains(data)
                                            ? Styles.red
                                            : Theme.of(context)
                                                .canvasColor
                                                .withOpacity(0.4),
                                        size: 20,
                                      ),
                                    ))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.frame!,
                                    style: Styles.mediumText(context),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 0),
                                    decoration: BoxDecoration(
                                        color: Styles.greenColor,
                                        borderRadius: BorderRadius.circular(3)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          data.overallRating!
                                              .round()
                                              .toString(),
                                          style: Styles.smallBoldText(context)
                                              .copyWith(color: Colors.white),
                                        ),
                                        const Gap(3),
                                        const Icon(
                                          Icons.star,
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                        const Gap(4),
                                        Container(
                                          height: 10,
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                        const Gap(4),
                                        Text(
                                          data.reviews!.length.toString(),
                                          style: Styles.smallBoldText(context)
                                              .copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
