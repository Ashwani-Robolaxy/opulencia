import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_empty_message.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final catData = ref.watch(catControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: "Your Wislist"),
      body: catData.wishList.isEmpty
          ? const EmptyStateMessage(
              message: "No Wishlist Found!",
              animationAsset: "assets/lottie/sad.json")
          : GridView.builder(
              itemCount: catData.wishList.length,
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.74,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                var data = catData.wishList[index];
                return Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor.withOpacity(0.07),
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
                          IconButton(
                              onPressed: () {
                                catData.wishList.removeAt(index);
                                setState(() {});
                              },
                              icon: const CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  CupertinoIcons.heart_fill,
                                  color: Colors.red,
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
                                    '4.3',
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
                                    '12',
                                    style: Styles.smallBoldText(context)
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            // const Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            // Text(
                            //   "${data.prices[0].price}${Strings.currency}",
                            //   style: Styles.mediumText(context),
                            // ),
                            // const Gap(4),
                            // Text(
                            //   "€200",
                            //   style: Styles.smallText(context).copyWith(
                            //       decorationColor: Theme.of(context)
                            //           .canvasColor
                            //           .withOpacity(0.4),
                            //       decoration: TextDecoration.lineThrough,
                            //       color: Theme.of(context)
                            //           .canvasColor
                            //           .withOpacity(0.4)),
                            // ),
                            // const Gap(8),
                            // Text(
                            //   "30%off",
                            //   style: Styles.smallBoldText(context)
                            //       .copyWith(color: Styles.orangeColor),
                            // ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
