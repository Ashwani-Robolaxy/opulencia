import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:opulencia/features/category/model/frame_cat_model.dart';
import 'package:opulencia/features/category/model/price_model.dart';
import 'package:opulencia/features/category/model/sub_product_model.dart';
import 'package:opulencia/features/category/repo/cat_repo.dart';


final catControllerProvider = Provider((ref) {
  final catRepositry = ref.watch(catRepositryProvider);
  return CatController(ref: ref, catRepositry: catRepositry);
});

class CatController {
  final CatRepo catRepositry;
  final ProviderRef ref;
  CatController({required this.ref, required this.catRepositry});

  int? selectedCatIndex;
  String? selectedSubCatId;
  String? selectedCatName;
  String? selectedSubCatName;
  String? selectedCommonTitle;
  int? selectedSubCatIndex;
  int? selectedFrameIndex;
  bool isViewAll = false;
// ************ GET FRAMES BY CATEGORY ***********************
  List<CategoryDetails>? catList = [];
  Future getFramesByCat({required BuildContext context}) async {
    try {
      await catRepositry
          .getFramesByCategory(
        context: context,
      )
          .then((value) {
        catList = value.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

// ************ GET PRICES ***********************
  List<PriceDetails>? priceList = [];
  Future getPrices({required BuildContext context}) async {
    try {
      await catRepositry
          .getPrices(
        context: context,
      )
          .then((value) {
        priceList = value.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

// ************ GET SUB CAT PRODUCTS ***********************
  List<SubProductDetail>? allProducList;
  Future getSubCatProducts({required BuildContext context}) async {
    try {
      await catRepositry
          .getSubProducts(
        subCatId: selectedSubCatId ?? "",
        context: context,
      )
          .then((value) {
        allProducList = value.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  List<SubProductDetail> wishList = [];

  String getFormattedUpdatedAt(String updatedAt) {
    final DateTime parsedDate = DateTime.parse(updatedAt);
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(parsedDate);
  }
}
