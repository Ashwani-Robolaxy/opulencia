import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/orders/model/order_history_model.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class OrderItemsScreen extends ConsumerStatefulWidget {
  OrderDetails? product;
  OrderItemsScreen({required this.product, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderItemsScreenState();
}

class _OrderItemsScreenState extends ConsumerState<OrderItemsScreen> {
  @override
  Widget build(BuildContext context) {
    var items = widget.product!.products;
    return Scaffold(
      appBar: myAppBar(context: context, title: "Order Items"),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: items[index].images!.isEmpty
                  ? Container(
                      width: 80,
                      height: 100.h,
                      color: Colors.white,
                      child: const Icon(Icons.error),
                    )
                  : CachedNetworkImage(
                      imageUrl: items[index].images![0].imageUrl.toString(),
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
                items[index].frame.toString(),
                style: Styles.mediumBoldText(context),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items[index].description.toString(),
                    maxLines: 2,
                    style: Styles.smallText(context).copyWith(
                        color: Theme.of(context).canvasColor.withOpacity(0.5)),
                  ),
                  Text(
                    items[index].framePrice.toString() + Strings.currency,
                    maxLines: 2,
                    style: Styles.mediumBoldText(context)
                        .copyWith(color: Styles.greenColor),
                  ),
                  widget.product!.status.toString().toLowerCase() ==
                              "delivered" &&
                          widget.product!.products![index].reviewSubmitted ==
                              "0"
                      ? SizedBox(
                          height: 20,
                          child: TextButton(
                            style: const ButtonStyle(
                                padding:
                                    WidgetStatePropertyAll(EdgeInsets.zero),
                                visualDensity: VisualDensity.compact),
                            onPressed: () {
                              context.go(
                                  "/${Routes.bottomNav}/${Routes.orders}/${Routes.rating}",
                                  extra: widget.product!.products![index]);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 14, color: Styles.blue),
                                const Gap(3),
                                Text(
                                  "Write a review",
                                  style: Styles.smallText(context)
                                      .copyWith(color: Styles.blue),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Gap(10);
          },
          itemCount: items!.length),
    );
  }
}
