import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/features/address/controller/address_controller.dart';
import 'package:opulencia/features/address/view/add_address_screen.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_empty_message.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  Color _randomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    final addData = ref.watch(addressControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: "My Addresses"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: addData.addressList.isEmpty
            ? const EmptyStateMessage(
                message: "No Address Found!",
                animationAsset: "assets/lottie/sad.json",
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return const Gap(10);
                },
                itemCount: addData.addressList.length,
                itemBuilder: (context, index) {
                  var address = addData.addressList[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      selectedIndex = index;
                      setState(() {});
                    },
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: selectedIndex == index
                                      ? Styles.primary
                                      : Colors.transparent),
                              borderRadius: BorderRadius.circular(17)),
                          child: Container(
                            width: 100.w,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.transparent,
                                  Styles.orangeColor
                                ]),
                                border: BorderDirectional(
                                    start: BorderSide(
                                        width: 50, color: Styles.primary)),
                                color: _randomColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address.title!,
                                        style: Styles.mediumBoldText(context),
                                      ),
                                      Text(
                                        "${address.province}\n${address.city}\n${address.address}\n${address.landmark}",
                                        style: Styles.smallText(context),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            address.title == "Home"
                                ? addData.addressIcons[0]
                                : address.title == "Work"
                                    ? addData.addressIcons[1]
                                    : address.title == "Hotel"
                                        ? addData.addressIcons[2]
                                        : addData.addressIcons[3],
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit,
                                size: 15,
                                color: Theme.of(context).canvasColor,
                              )),
                        )
                      ],
                    ),
                  );
                }),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddAddressScreen(),
              )).then((value) {
            if (value['refresh'] == "refreshed") {
              setState(() {});
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Styles.primary),
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                color: Styles.primary,
                size: 20,
              ),
              Text(
                'Add Address',
                style: Styles.mediumBoldText(context)
                    .copyWith(color: Styles.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
