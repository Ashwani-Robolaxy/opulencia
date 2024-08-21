import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/cart/controller/cart_controller.dart';
import 'package:opulencia/features/cart/model/order_model.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/boxes/boxes.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:opulencia/utils/widgets/my_empty_message.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    final cartData = ref.read(cartControllerProvider);
    cartData.totalAmount();
  }

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: "My Cart", action: [
        orderBox.isEmpty
            ? const SizedBox()
            : TextButton(
                onPressed: () async {
                  await cartData.clearCart();
                  setState(() {});
                },
                child: Text(
                  'Clear Cart',
                  style: Styles.mediumBoldText(context)
                      .copyWith(color: Styles.red),
                ))
      ]),
      body: orderBox.isEmpty
          ? const EmptyStateMessage(
              message: "Found nothing in cart!",
              animationAsset: "assets/lottie/cart.json")
          : Column(
              children: [
                ListView.separated(
                  // physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Theme.of(context).canvasColor.withOpacity(0.1),
                    );
                  },
                  itemCount: orderBox.length,
                  itemBuilder: (context, index) {
                    var item = orderBox.getAt(index)!;
                    int itemCount = item.quantity;

                    return Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        extentRatio: 0.3,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(10),
                            autoClose: true,
                            onPressed: (context) async {
                              cartData.removeFromCart(index: index);
                              setState(() {});
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: CartItemWidget2(
                        onTapDec: () {
                          if (itemCount == 1) {
                            cartData.removeFromCart(index: index);
                            setState(() {});
                          }
                          if (itemCount != 0) {
                            cartData.decreaseQty(index: index);
                            setState(() {});
                          }
                        },
                        onTapInc: () {
                          setState(() {});
                          cartData.increaseQty(index: index);
                          setState(() {});
                        },
                        order: item,
                        index: index,

                        title: item.frameId,
                        // price: '1kg, ₹${flutterCart.cartItem[index].unitPrice}',
                        price: '₹${item.priceId}',
                        itemCount: item.quantity,
                      ),
                    );
                  },
                ),
                Container(
                  color: Styles.primary.withOpacity(0.1),
                  width: 100.w,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        'Total: ${cartData.totalAmount()} ${Strings.currency}',
                        style: Styles.mediumBoldText(context),
                      ),
                    ),
                  ),
                )
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: orderBox.isEmpty
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyCustomButton(
                onPressed: () {
                  context.go(
                      "/${Routes.bottomNav}/${Routes.cart}/${Routes.orderaddress}");
                },
                label: "Continue",
              ),
            ),
    );
  }
}

// ignore: must_be_immutable
class CartItemWidget2 extends ConsumerStatefulWidget {
  final String title;
  final String price;
  final OrderModel order;
  void Function()? onTapInc;
  void Function()? onTapDec;

  int itemCount;
  int index;

  CartItemWidget2({
    super.key,
    required this.title,
    required this.price,
    required this.order,
    required this.onTapInc,
    required this.onTapDec,
    required this.itemCount,
    required this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CartItemWidget2State();
}

class _CartItemWidget2State extends ConsumerState<CartItemWidget2> {
  @override
  Widget build(BuildContext context) {
    // final cartData = ref.watch(cartControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              widget.order.image,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.order.name,
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontSize: 16,
                      fontFamily: Strings.appFont,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    " [${widget.order.selectedSize}]",
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontSize: 12,
                      fontFamily: Strings.appFont,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Text(
                widget.order.price + Strings.currency,
                style: TextStyle(
                  color: const Color(0xFFFF314A),
                  fontSize: 16,
                  fontFamily: Strings.appFont,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Selected Color: ${widget.order.isBordered ? "Bordered" : "Borderless"} ${widget.order.frameColor}",
                style: Styles.smallText(context),
              ),
            ],
          ),
          const Spacer(),
          // Text(
          //   "${(double.parse(widget.order.price) * widget.order.quantity)}${Strings.currency}",
          //   style: Styles.mediumText(context)
          //       .copyWith(fontSize: 14, color: Theme.of(context).canvasColor),
          // ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Styles.primary),
            child: Row(
              children: [
                InkWell(
                  onTap: widget.onTapDec,
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),

                // productList[index].stockCount! display
                SizedBox(
                  width: 25,
                  height: 22,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.order.quantity.toString(),
                      style: Styles.mediumText(context)
                          .copyWith(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Increment button
                InkWell(
                  onTap: widget.onTapInc,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
