import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductDetail2 extends ConsumerStatefulWidget {
  const ProductDetail2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductDetail2State();
}

class _ProductDetail2State extends ConsumerState<ProductDetail2> {
  bool isLiked = false;
  bool isCollapsed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(
          context: context,
          title: "",
          foregroundColor: Colors.white,
          action: [
            IconButton(
                onPressed: () {
                  isLiked = !isLiked;
                  setState(() {});
                },
                icon: Icon(
                    isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart))
          ]),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/images/5.jpg',
              height: 100.h,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              child: Column(
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 6,
                      ),
                      Gap(5),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 6,
                      ),
                      Gap(5),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 6,
                      ),
                    ],
                  ),
                  isCollapsed
                      ? ElevatedButton(
                          style: const ButtonStyle(
                              shape: WidgetStatePropertyAll(StadiumBorder(
                                  side: BorderSide(
                                      width: 2, color: Colors.white)))),
                          onPressed: () {
                            isCollapsed = false;
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Text(
                                'See Details',
                                style: Styles.mediumBoldText(context),
                              ),
                              const Icon(Icons.expand_less)
                            ],
                          ))
                      : const SizedBox(),
                  const Gap(7),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: 90.w,
                    height: isCollapsed ? 0 : 50.h,
                    decoration: BoxDecoration(
                        // boxShadow: const [
                        //   BoxShadow(blurRadius: 2, spreadRadius: 2)
                        // ],
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Love Photo Frame 2 x 2',
                                        style: Styles.mediumBoldText(context)
                                            .copyWith(fontSize: 18),
                                      ),
                                      Text(
                                        '€200',
                                        style: Styles.mediumBoldText(context)
                                            .copyWith(
                                                color: Colors.green,
                                                fontSize: 20),
                                      ),
                                      RatingBar.builder(
                                        initialRating: 3,
                                        minRating: 1,
                                        itemSize: 14,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        isCollapsed = true;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.expand_more,
                                        size: 30,
                                        color: Theme.of(context).canvasColor,
                                      ))
                                  // MyCustomButton(
                                  //     width: 30.w,
                                  //     onPressed: () {},
                                  //     label: "Add to Cart")
                                ],
                              ),
                              Text(
                                lorem(paragraphs: 2, words: 60),
                                maxLines: 30,
                                style: Styles.mediumText(context).copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .canvasColor
                                        .withOpacity(1)),
                              ),
                              const Spacer(),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  MyCustomButton(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Styles.primary,
                                    width: 40.w,
                                    label: "Add to Cart",
                                    onPressed: () {},
                                  ),
                                  MyCustomButton(
                                    width: 40.w,
                                    label: "Order Now",
                                    onPressed: () {},
                                  ),
                                ],
                              )
                              // const Gap(100)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     MyCustomButton(width: 44.w, onPressed: () {}, label: "Order Now"),
      //     MyCustomButton(
      //         backgroundColor: Colors.transparent,
      //         width: 44.w,
      //         onPressed: () {},
      //         label: "Add to Cart"),
      //   ],
      // ),
    );
  }
}
