import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/category/model/sub_product_model.dart';
import 'package:opulencia/features/home/model/banner_model.dart';
import 'package:opulencia/features/home/repo/home_repo.dart';

final homeControllerProvider = Provider((ref) {
  final homeRepositry = ref.watch(homeRepositryProvider);
  return HomeController(ref: ref, homeRepositry: homeRepositry);
});

class HomeController {
  final HomeRepo homeRepositry;
  final ProviderRef ref;
  HomeController({required this.ref, required this.homeRepositry});

  // ************ GET FRAMES BY CATEGORY ***********************
  List<SubProductDetail>? trendingList = [];
  Future getTrendingFrames({required BuildContext context}) async {
    try {
      await homeRepositry
          .getTrendingFrames(
        context: context,
      )
          .then((value) {
        trendingList = value.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  // ************ NEW IN THE MARKET FRAMES ***********************
  List<SubProductDetail>? newInMarketList = [];
  Future getNewInMarketFrames({required BuildContext context}) async {
    try {
      await homeRepositry
          .getNewInMarketFrames(
        context: context,
      )
          .then((value) {
        newInMarketList = value.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  // ************ RECENT ORDERS ***********************
  List<SubProductDetail>? recentOrderList = [];
  Future recentOrders({required BuildContext context}) async {
    try {
      await homeRepositry
          .recentOrders(
        context: context,
      )
          .then((value) {
        recentOrderList = value.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  // ************ SEARCH PRODUCT ***********************
  List<SubProductDetail>? searchList = [];
  bool isLoadingSearch = false;
  Future searchFrames(
      {required BuildContext context, required String searchText}) async {
    try {
      await homeRepositry
          .searchFrames(
        searchText: searchText,
        context: context,
      )
          .then((value) {
        searchList = value.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  // ************ GET BANNER ***********************
  List<BannerDetail>? bannerList = [];
  Future getBanner({required BuildContext context}) async {
    try {
      await homeRepositry
          .getBanner(
        context: context,
      )
          .then((value) {
        bannerList = value.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  // ************ GET PRIVACY POLICY ***********************
  String privacyData = "";
  Future getPrivacyPolicy({required BuildContext context}) async {
    try {
      await homeRepositry
          .getPrivacy(
        context: context,
      )
          .then((value) {
        privacyData = value!.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  // ************ GET REFUND POLICY ***********************
  String refundPolicyData = "";
  Future getRefundPolicy({required BuildContext context}) async {
    try {
      await homeRepositry
          .getRefundPrivacy(
        context: context,
      )
          .then((value) {
        refundPolicyData = value!.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  // ************ GET TERMS AND CONDITIONS ***********************
  String termsAndCondtionsData = "";
  Future getTermsAndCondtions({required BuildContext context}) async {
    try {
      await homeRepositry
          .getTermsAndConditions(
        context: context,
      )
          .then((value) {
        termsAndCondtionsData = value!.details;
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
}
