
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:opulencia/features/cart/model/make_order_model.dart';
import 'package:opulencia/features/cart/model/order_model.dart';
import 'package:opulencia/features/cart/repo/cart_repo.dart';
import 'package:opulencia/features/orders/controller/order_controller.dart';
import 'package:opulencia/utils/boxes/boxes.dart';
import 'package:opulencia/utils/strings/route_strings.dart';

final cartControllerProvider = Provider((ref) {
  final cartRepositry = ref.watch(cartRepositryProvider);
  return CartController(cartRepositry: cartRepositry, ref: ref);
});

class CartController {
  final CartRepo cartRepositry;
  final ProviderRef ref;
  CartController({required this.cartRepositry, required this.ref});

  void addToCart({required OrderModel order}) {
    orderBox.add(order).then((value) {});
  }

  void removeFromCart({required int index}) async {
    await orderBox.deleteAt(index);
  }

  Future clearCart() async {
    await orderBox.clear();
  }

  num totalAmount() {
    num totalPrice = 0;
    for (var i = 0; i < orderBox.length; i++) {
      totalPrice = totalPrice +
          (double.parse(orderBox.getAt(i)!.price) *
              orderBox.getAt(i)!.quantity);
    }
    return totalPrice;
  }

  void increaseQty({required int index}) {
    orderBox.getAt(index)?.quantity++;
  }

  void decreaseQty({required int index}) {
    orderBox.getAt(index)?.quantity--;
  }

  // ************** MAKE ORDER **************
  String? selectedAddressId;
  Future<void> makeOrder({required BuildContext context}) async {
    try {
      List<Product> productList = orderBox.values
          .map((order) => Product.fromOrderModel(order))
          .toList();

      await cartRepositry
          .makeOrder(
        addressId: selectedAddressId!,
        totalPrice: totalAmount().toString(),
        makeorderDetails: productList,
        context: context,
      )
          .then((value) async {
        clearCart();
        // ignore: use_build_context_synchronously
        final orderData = ref.watch(orderControllerProvider);
        await orderData.getOrderHistory(context: context);

        // ignore: use_build_context_synchronously
        context.go('/${Routes.bottomNav}');
        // Navigator.pop(context, {"refresh": "refreshed"});
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
}
