import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/orders/model/custom_order_model.dart';
import 'package:opulencia/features/orders/model/order_history_model.dart';
import 'package:opulencia/features/orders/repo/order_repo.dart';

final orderControllerProvider = Provider((ref) {
  final orderRepositry = ref.watch(orderRepositryProvider);
  return OrderController(ref: ref, orderRepositry: orderRepositry);
});

class OrderController {
  final OrderRepo orderRepositry;
  final ProviderRef ref;
  OrderController({required this.ref, required this.orderRepositry});

  // ************ GET ORDER HISTORY ***********************
  List<OrderDetails> orderHistoryList = [];
  Future getOrderHistory({required BuildContext context}) async {
    try {
      await orderRepositry
          .getOrderHistory(
        context: context,
      )
          .then((value) {
        orderHistoryList = value!.details!;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
  // ************ GET CUSTOM ORDER HISTORY ***********************
  List<CustomOrderList> customOrderHistoryList = [];
  Future getCustomOrderHistory({required BuildContext context}) async {
    try {
      await orderRepositry
          .getCustomOrderHistory(
        context: context,
      )
          .then((value) {
        customOrderHistoryList = value!.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

// ************ RATE ORDER ***********************
  Future<void> addReview({
    required BuildContext context,
    required String productId,
    required int rating,
    required String review,
  }) async {
    try {
      EasyLoading.show(status: "Submitting...");
      await orderRepositry
          .addReview(
        productId: productId,
        rating: rating,
        review: review,
        context: context,
      )
          .then((value) async {
        await getOrderHistory(context: context);
        
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
}
