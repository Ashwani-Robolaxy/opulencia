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

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  // bool isPendingSelected = true;
  @override
  Widget build(BuildContext context) {
    final orderData = ref.watch(orderControllerProvider);
    void showRatingDialog() {
      final dialog = RatingDialog(
        initialRating: 1.0,

        // your app's name?
        title: Text(
          'Rate this purchase!',
          textAlign: TextAlign.center,
          style: Styles.largeText(context).copyWith(color: Colors.white),
        ),
        // encourage your user to leave a high rating?
        message: Text(
          'Tap a star to set your rating. Add more description here if you want.',
          maxLines: 2,
          textAlign: TextAlign.center,
          style: Styles.smallText(context).copyWith(color: Colors.white),
        ),
        // your app's logo?
        // image: const FlutterLogo(size: 100),
        submitButtonText: 'Submit',

        submitButtonTextStyle:
            Styles.mediumBoldText(context).copyWith(color: Colors.white),
        commentHint: 'Set your custom comment hint',

        onCancelled: () => print('cancelled'),
        onSubmitted: (response) {
          print('rating: ${response.rating}, comment: ${response.comment}');
        },
      );

      // show the dialog
      showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) => dialog,
      );
    }

    return Scaffold(
      body: orderData.orderHistoryList.isEmpty
          ? const EmptyStateMessage(
              message: "No Order Found!",
              animationAsset: "assets/lottie/sad.json")
          : CustomMaterialIndicator(
              backgroundColor: Styles.primary,
              onRefresh: () async {
                await orderData.getOrderHistory(context: context);
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
                itemCount: orderData.orderHistoryList.length,
                itemBuilder: (context, index) {
                  var order = orderData.orderHistoryList[index];

                  return InkWell(
                    onTap: () {
                      context.go(
                          "/${Routes.bottomNav}/${Routes.orders}/${Routes.orderItems}",
                          extra: order);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          // order.products![0].images == null
                          //     ? const SizedBox()
                          //     : ClipRRect(
                          //         borderRadius: BorderRadius.circular(4),
                          //         child: CachedNetworkImage(
                          //           imageUrl: order
                          //               .products![0].images!.first.imageUrl
                          //               .toString(),
                          //           width: 70,
                          //           height: 100,
                          //           fit: BoxFit.cover,
                          //           placeholder: (context, url) =>
                          //               Shimmer.fromColors(
                          //             baseColor: Colors.grey[300]!,
                          //             highlightColor: Colors.grey[100]!,
                          //             child: Container(
                          //               width: 70,
                          //               height: 100,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           errorWidget: (context, url, error) =>
                          //               const Icon(Icons.error),
                          //         ),
                          //       ),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Order ID: ${order.orderNo!}",
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
                                "${order.products!.length} Items Ordered",
                                style: Styles.smallText(context),
                              ),
                              Text(
                                order.orderTotal! + Strings.currency,
                                style: TextStyle(
                                  color: const Color(0xFFFF314A),
                                  fontSize: 16,
                                  fontFamily: Strings.appFont,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Status: ",
                                    style: Styles.smallText(context).copyWith(),
                                  ),
                                  Text(
                                    order.status!.toUpperCase(),
                                    style: Styles.smallText(context).copyWith(
                                        color: order.status!.toUpperCase() ==
                                                "PENDING"
                                            ? Styles.red
                                            : order.status!.toUpperCase() ==
                                                    "IN-TRANSIT"
                                                ? Styles.orangeColor
                                                : Styles.greenColor),
                                  ),
                                ],
                              ),
                              Text(
                                "Delivering at ${order.address?.title}",
                                style: Styles.smallText(context),
                              ),
                              // order.status!.toUpperCase() == "DELIVERED"
                              //     ? SizedBox(
                              //         height: 20,
                              //         child: TextButton(
                              //           style: const ButtonStyle(
                              //               padding: MaterialStatePropertyAll(
                              //                   EdgeInsets.zero),
                              //               visualDensity:
                              //                   VisualDensity.compact),
                              //           onPressed: () {
                              //             context.go(
                              //                 "/${Routes.bottomNav}/${Routes.orders}/${Routes.rating}",
                              //                 extra: order);
                              //           },
                              //           child: Row(
                              //             children: [
                              //               Icon(Icons.edit,
                              //                   size: 14, color: Styles.blue),
                              //               const Gap(3),
                              //               Text(
                              //                 "Write a review",
                              //                 style: Styles.smallText(context)
                              //                     .copyWith(color: Styles.blue),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //     : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 10),
      //   child: Column(
      //     children: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           InkWell(
      //             borderRadius: const BorderRadius.all(Radius.circular(10)),
      //             onTap: () {
      //               isPendingSelected = true;
      //               setState(() {});
      //             },
      //             child: Container(
      //               alignment: Alignment.center,
      //               width: 46.w,
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: 20, vertical: 10),
      //               decoration: BoxDecoration(
      //                 color: isPendingSelected
      //                     ? Styles.primary.withOpacity(0.3)
      //                     : Theme.of(context).canvasColor.withOpacity(0.06),
      //                 borderRadius: BorderRadius.circular(10),
      //               ),
      //               child: Text(
      //                 'Pending',
      //                 style: Styles.mediumBoldText(context),
      //               ),
      //             ),
      //           ),
      //           InkWell(
      //             borderRadius: const BorderRadius.all(Radius.circular(10)),
      //             onTap: () {
      //               isPendingSelected = false;
      //               setState(() {});
      //             },
      //             child: Container(
      //               alignment: Alignment.center,
      //               width: 46.w,
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: 20, vertical: 10),
      //               decoration: BoxDecoration(
      //                 color: !isPendingSelected
      //                     ? Styles.primary.withOpacity(0.3)
      //                     : Theme.of(context).canvasColor.withOpacity(0.06),
      //                 borderRadius: BorderRadius.circular(10),
      //               ),
      //               child: Text(
      //                 'Completed',
      //                 style: Styles.mediumBoldText(context),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       Expanded(
      //           child: isPendingSelected
      //               ? const PendingOrderScreen()
      //               : const CompletedOrderScreen())
      //     ],
      //   ),
      // ),
    );
  }
}
