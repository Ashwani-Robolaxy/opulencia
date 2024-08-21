import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/address/model/address_model.dart';

import 'package:opulencia/features/address/repo/address_repo.dart';
import 'package:opulencia/utils/strings/icon_strings.dart';

final addressControllerProvider = Provider((ref) {
  final addressRepositry = ref.watch(addressRepositryProvider);
  return AddressController(ref: ref, addressRepositry: addressRepositry);
});

class AddressController {
  final AddressRepo addressRepositry;
  final ProviderRef ref;
  AddressController({required this.ref, required this.addressRepositry});

  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController provinceController = TextEditingController();

  List addressType = [
    "Home",
    "Work",
    "Hotel",
    "Other",
  ];
  List addressIcons = [
    IconStrings.home,
    IconStrings.work,
    IconStrings.hotel,
    IconStrings.location,
  ];
  int selectedAddressIndex = 0;
  Future addAddress({required BuildContext context}) async {
    try {
      EasyLoading.show(status: 'Adding Address...');
      await addressRepositry
          .addAddress(
        title: addressType[selectedAddressIndex],
        province: provinceController.text,
        city: cityController.text,
        address: addressController.text,
        landmark: landmarkController.text,
        context: context,
      )
          .then((value) async {
        await getUserAddress(context: context);
        addressController.clear();
        landmarkController.clear();
        cityController.clear();
        provinceController.clear();
        // ignore: use_build_context_synchronously
        Navigator.pop(context, {"refresh": "refreshed"});
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

// ************ GET USER ADDRESS ***********************

  List<AddressDetails> addressList = [];
  Future getUserAddress({required BuildContext context}) async {
    try {
      await addressRepositry
          .getUserAddress(
        context: context,
      )
          .then((value) {
        addressList = value!.details!;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
}
