import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/orders/controller/order_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/widgets/my_empty_message.dart';
import 'package:rating_dialog/rating_dialog.dart';

class AiOrderScreen extends ConsumerStatefulWidget {
  const AiOrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<AiOrderScreen> {
  // bool isPendingSelected = true;

  fetchOrder() async {
    final orderData = ref.read(orderControllerProvider);
    await orderData.aiOrderHistory(context: context);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = ref.watch(orderControllerProvider);

    return Scaffold(
      body: orderData.customOrderHistoryList.isNotEmpty
          ? const EmptyStateMessage(
              message: "No Order Found!",
              animationAsset: "assets/lottie/sad.json")
          : CustomMaterialIndicator(
              backgroundColor: Styles.primary,
              onRefresh: () async {
                await orderData.aiOrderHistory(context: context);
                setState(() {});
              },
              indicatorBuilder: (context, controller) {
                return const Icon(
                  Icons.ac_unit,
                  color: Colors.white,
                  size: 30,
                );
              },
              child: ListView.separated(
                // physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,

                separatorBuilder: (context, index) {
                  return Divider(
                    color: Theme.of(context).canvasColor.withOpacity(0.1),
                  );
                },
                itemCount: orderData.aiOrderList.length,
                itemBuilder: (context, index) {
                  var order = orderData.aiOrderList[index];

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: order.enhancedImage,
                          height: 100,
                          width: 90,
                          fit: BoxFit.contain,
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Order ID: ${order.orderNo}",
                                  style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontSize: 16,
                                    fontFamily: Strings.appFont,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              order.orderTotal + Strings.currency,
                              style: TextStyle(
                                color: const Color(0xFFFF314A),
                                fontSize: 16,
                                fontFamily: Strings.appFont,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       "Order Type: ",
                            //       style: Styles.smallText(context).copyWith(),
                            //     ),
                            //     Text(
                            //       order.type.toUpperCase(),
                            //       style: Styles.smallText(context),
                            //     ),
                            //   ],
                            // ),
                            Row(
                              children: [
                                Text(
                                  "Status: ",
                                  style: Styles.smallText(context).copyWith(),
                                ),
                                Text(
                                  order.status.toUpperCase(),
                                  style: Styles.smallText(context).copyWith(
                                      color: order.status.toUpperCase() ==
                                              "PENDING"
                                          ? Styles.red
                                          : order.status.toUpperCase() ==
                                                  "IN-TRANSIT"
                                              ? Styles.orangeColor
                                              : Styles.greenColor),
                                ),
                              ],
                            ),
                            Text(
                              "Delivering at ${order.address.title}",
                              style: Styles.smallText(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
