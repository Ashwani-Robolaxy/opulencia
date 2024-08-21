import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/features/address/controller/address_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:opulencia/utils/widgets/my_textfield.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final addData = ref.watch(addressControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: "Add New Address"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              "Address Type",
                              style: Styles.mediumText(context),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          itemCount: addData.addressType.length,
                          separatorBuilder: (context, index) {
                            return const Gap(10);
                          },
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap: () {
                                  addData.selectedAddressIndex = index;
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                        color: addData.selectedAddressIndex ==
                                                index
                                            ? Styles.primary.withOpacity(0.5)
                                            : Colors.transparent,
                                      )
                                    ],
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 2,
                                      color:
                                          addData.selectedAddressIndex == index
                                              ? Styles.primary
                                              : Theme.of(context)
                                                  .canvasColor
                                                  .withOpacity(0.2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        addData.addressIcons[index],
                                        height: 18,
                                        color: Theme.of(context).canvasColor,
                                      ),
                                      const Gap(8),
                                      Text(
                                        addData.addressType[index],
                                        style: Styles.mediumBoldText(context),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      MyTextField(
                        controller: addData.provinceController,
                        hintText: "Enter Province",
                        hasTitle: true,
                        title: "Province",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your province';
                          }
                          return null;
                        },
                      ),
                      const Gap(5),
                      MyTextField(
                        controller: addData.cityController,
                        hintText: "Enter City",
                        hasTitle: true,
                        title: "City",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your city';
                          }
                          return null;
                        },
                      ),
                      const Gap(5),
                      MyTextField(
                        controller: addData.addressController,
                        hintText: "Enter Address",
                        hasTitle: true,
                        maxLines: 3,
                        title: "Address",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const Gap(5),
                      MyTextField(
                        controller: addData.landmarkController,
                        hintText: "Enter Landmark",
                        hasTitle: true,
                        title: "Landmark",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a landmark';
                          }
                          return null;
                        },
                      ),
                      const Gap(5),
                      const Gap(20),
                      MyCustomButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await addData.addAddress(context: context);
                          }
                        },
                        label: "Add",
                      ),
                      const Gap(30),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// form 60
// aadhar mother
// Relative Name, mobile and address
// mother's mother name--Biyasa Devi


// Mother's Mother Name: Biyasa Devi

// *Relative Detail*
// Name: Vikas
// Contact No.: 99885 40540
// Relation: Brother-in-law
// Address: 1636, Muirwoods ecocity, Altus phase 2 Sector 24 Mullanpur New Chandigarh

// *Friend Detail*
// Name: Rohit Sharma
// Contact No.:8968149316
// Address: H.no. 661/1, Dashmesh Nagar, Naya Gaon, Mohali, Punjab 160103




