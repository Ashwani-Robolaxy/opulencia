import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/ai/controller/ai_controller.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/features/category/model/price_model.dart';
import 'package:opulencia/features/home/view/sale_product_screen.dart';
import 'package:opulencia/lang/delegates/localizations_delegate.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:opulencia/utils/utils.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PostAiScreen extends ConsumerStatefulWidget {
  const PostAiScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostAiScreenState();
}

class _PostAiScreenState extends ConsumerState<PostAiScreen> {
  List<Color> frameColors = [
    Colors.black,
    Colors.red,
    Colors.white,
  ];
  int selectedColorIndex = 0;
  bool isBorderedSelected = true;
  int selectedSizeIndex = 0;

  String? selectedPriceId;

  // Function to download and save the enhanced image to the gallery

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    final catData = ref.watch(catControllerProvider);
    List<PriceDetails> type1Prices =
        catData.priceList!.where((price) => price.type == '1').toList();
    List<PriceDetails> type0Prices =
        catData.priceList!.where((price) => price.type == '0').toList();
    final aiData = ref.watch(aiControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: "Select Paramters"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  aiData.enhancedImageUrl!,
                  // height: 100.w,
                  // width: 100.w,
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${Utils.currencyConvert(price: isBorderedSelected ? (double.parse(type1Prices[selectedSizeIndex].endPrice)) : (double.parse(type0Prices[selectedSizeIndex].endPrice)))} ${Strings.currency}",
                  style: Styles.largeBoldText(context)
                      .copyWith(color: Styles.greenColor),
                ),
              ),
              Text(
                "Border Type",
                style: Styles.mediumBoldText(context),
              ),
              const Gap(5),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      isBorderedSelected = true;
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                          border: Border.all(
                              width: 1,
                              color: isBorderedSelected
                                  ? Styles.orangeColor
                                  : Theme.of(context)
                                      .canvasColor
                                      .withOpacity(0.3))),
                      child: Text(
                        'Bordered',
                        style: Styles.smallText(context).copyWith(
                            color: isBorderedSelected
                                ? Theme.of(context).canvasColor
                                : Theme.of(context)
                                    .canvasColor
                                    .withOpacity(0.3)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      isBorderedSelected = false;
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          border: Border.all(
                              width: 1,
                              color: isBorderedSelected
                                  ? Theme.of(context)
                                      .canvasColor
                                      .withOpacity(0.3)
                                  : Styles.orangeColor)),
                      child: Text(
                        'Borderless',
                        style: Styles.smallText(context).copyWith(
                            color: isBorderedSelected
                                ? Theme.of(context).canvasColor.withOpacity(0.3)
                                : Theme.of(context).canvasColor),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Text(
                lang.translate(Strings.frameColor),
                style: Styles.mediumBoldText(context),
              ),
              SizedBox(
                width: 100.w,
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return const Gap(10);
                  },
                  itemCount: frameColors.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        selectedColorIndex = index;
                        setState(() {});
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius:
                                      selectedColorIndex == index ? 1 : 0,
                                  blurRadius:
                                      selectedColorIndex == index ? 6 : 0,
                                  color: frameColors[index].withOpacity(0.4))
                            ],
                            border: Border.all(
                                width: selectedColorIndex == index ? 2 : 0,
                                color: Theme.of(context).canvasColor),
                            shape: BoxShape.circle,
                            color: frameColors[index]),
                        child: selectedColorIndex == index
                            ? Icon(
                                Icons.check,
                                size: 15,
                                color: Styles.orangeColor,
                              )
                            : const SizedBox(),
                      ),
                    );
                  },
                ),
              ),
              const Gap(10),
              Text(
                lang.translate(Strings.size),
                style: Styles.mediumBoldText(context),
              ),
              const Gap(4),
              SizedBox(
                width: 100.w,
                height: 30,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return const Gap(10);
                  },
                  itemCount: isBorderedSelected
                      ? type1Prices.length
                      : type0Prices.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        selectedPriceId = isBorderedSelected
                            ? type1Prices[index].id
                            : type0Prices[index].id;
                        selectedSizeIndex = index;
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                width: selectedPriceId == null
                                    ? 0.2
                                    : selectedSizeIndex == index
                                        ? 2
                                        : 0.2,
                                color: Styles.orangeColor),
                            color: Theme.of(context).scaffoldBackgroundColor),
                        child: Text(
                          isBorderedSelected
                              ? type1Prices[index].size
                              : type0Prices[index].size,
                          style:
                              Styles.mediumText(context).copyWith(fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Gap(20),
              MyCustomButton(
                  onPressed: () {
                    if (selectedPriceId != null) {
                      context.go(
                          "/${Routes.bottomNav}/${Routes.aiHome}/${Routes.postAi}/${Routes.enhancedOrderAddress}",
                          extra: {
                            "frameColor": selectedColorIndex == 0
                                ? "Black"
                                : selectedColorIndex == 1
                                    ? "Red"
                                    : "White",
                            "frameType": isBorderedSelected ? "1" : "0",
                            "recordId": aiData.recordId,
                            "sizeId": isBorderedSelected
                                ? type1Prices[selectedSizeIndex].id
                                : type0Prices[selectedSizeIndex].id
                          });
                    } else {
                      MyToast.failToast("Select Size", context);
                    }
                  },
                  label: "Select Address"),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
