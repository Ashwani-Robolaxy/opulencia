import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/features/orders/model/custom_order_model.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class CustomOrderItemsScreen extends ConsumerStatefulWidget {
  CustomOrderList? product;
  CustomOrderItemsScreen({required this.product, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderItemsScreenState();
}

class _OrderItemsScreenState extends ConsumerState<CustomOrderItemsScreen> {
  @override
  Widget build(BuildContext context) {
    var items = widget.product!.details;
    return Scaffold(
      appBar: myAppBar(context: context, title: "Order Items"),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: items.frameImage.isEmpty
                  ? Container(
                      width: 80,
                      height: 100.h,
                      color: Colors.white,
                      child: const Icon(Icons.error),
                    )
                  : CachedNetworkImage(
                      imageUrl: items.frameImage,
                      height: 200,
                      width: 80,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 80,
                          height: 100.h,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
              title: Text(
                items.frameColor.toString(),
                style: Styles.mediumBoldText(context),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items.customDetails.toString(),
                    maxLines: 2,
                    style: Styles.smallText(context).copyWith(
                        color: Theme.of(context).canvasColor.withOpacity(0.5)),
                  ),
                  Text(
                    items.price.toString() + Strings.currency,
                    maxLines: 2,
                    style: Styles.mediumBoldText(context)
                        .copyWith(color: Styles.greenColor),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Gap(10);
          },
          itemCount: 1),
    );
  }
}
