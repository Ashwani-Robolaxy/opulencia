import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/features/category/model/sub_product_model.dart';
import 'package:opulencia/features/product/view/common_product_detail_screen.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MyAllProductsScreen extends ConsumerStatefulWidget {
  List<SubProductDetail> productList;
  MyAllProductsScreen({required this.productList, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyAllProductsScreenState();
}

class _MyAllProductsScreenState extends ConsumerState<MyAllProductsScreen> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final catData = ref.watch(catControllerProvider);

    return Scaffold(
      appBar:
          myAppBar(context: context, title: catData.selectedCommonTitle ?? ""),
      body: MasonryGridView.count(
        itemCount: widget.productList.length,
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        itemBuilder: (context, index) {
          var data = widget.productList[index];

          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CommonProductDetail(
                    productDetailData: data,
                  );
                },
              ));
            },
            child: Container(
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
                                data.overallRating!.round().toString(),
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
