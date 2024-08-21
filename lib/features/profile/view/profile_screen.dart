import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/features/auth/controller/auth_controller.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/features/orders/controller/order_controller.dart';
import 'package:opulencia/features/profile/view/edit_profile_screen.dart';
import 'package:opulencia/lang/delegates/localizations_delegate.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/icon_strings.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';

import 'package:opulencia/utils/widgets/my_icon_and_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var authData = ref.watch(authControllerProvider);
    final orderData = ref.watch(orderControllerProvider);
    final catData = ref.watch(catControllerProvider);
    var lang = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(MediaQuery.of(context).padding.top),
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: IconStrings.dummyDp,
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.cover,
                  ),
                ),
                const Gap(10),
                Text(
                  authData.userData!.firstName == ""
                      ? "Unnamed"
                      : authData.userData!.firstName!.toUpperCase(),
                  style:
                      Styles.mediumBoldText(context).copyWith(letterSpacing: 4),
                ),
                // Text(
                //   authData.userData!.email == ""
                //       ? "unknown@gmail.com"
                //       : authData.userData!.email!.toUpperCase(),
                //   style: Styles.mediumBoldText(context).copyWith(
                //       fontSize: 12,
                //       color: Theme.of(context).canvasColor.withOpacity(0.5)),
                // ),

                InkWell(
                  onTap: () {
                    FlutterClipboard.copy(
                            authData.userData!.accountId.toString())
                        .then((value) => print('copied'));
                    MyToast.successToast("Id Copied", context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        authData.userData!.accountId == ""
                            ? ""
                            : ("ID: ${authData.userData!.accountId!}"),
                        style: Styles.mediumBoldText(context).copyWith(
                            fontSize: 12,
                            color:
                                Theme.of(context).canvasColor.withOpacity(0.5)),
                      ),
                      const Gap(4),
                      Icon(
                        Icons.copy,
                        size: 13,
                        color: Theme.of(context).canvasColor.withOpacity(0.5),
                      )
                    ],
                  ),
                ),

                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go("/${Routes.bottomNav}/${Routes.favorite}");
                      },
                      child: Column(
                        children: [
                          Text(
                            lang.translate(Strings.wishlist).toUpperCase(),
                            style: Styles.mediumBoldText(context).copyWith(
                                color: Theme.of(context)
                                    .canvasColor
                                    .withOpacity(0.7),
                                fontSize: 12),
                          ),
                          Text(
                            catData.wishList.length.toString(),
                            style: Styles.mediumBoldText(context)
                                .copyWith(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 40,
                        child: VerticalDivider(
                          thickness: 2,
                          color: Theme.of(context).canvasColor,
                        )),
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        context.go("/${Routes.bottomNav}/${Routes.orders}");
                      },
                      child: Column(
                        children: [
                          Text(
                            lang.translate(Strings.orders).toUpperCase(),
                            style: Styles.mediumBoldText(context).copyWith(
                                color: Theme.of(context)
                                    .canvasColor
                                    .withOpacity(0.7),
                                fontSize: 12),
                          ),
                          Text(
                            orderData.orderHistoryList.length.toString(),
                            style: Styles.mediumBoldText(context)
                                .copyWith(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                MyIconAndText(
                  imagePath: IconStrings.profile,
                  text: lang.translate(Strings.profileInfo),
                  fontSize: 16,
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        )).then((result) {
                      if (result != null && result is Map<String, dynamic>) {
                        if (result["refresh"] == "refreshed") {
                          setState(() {});
                        }
                      }
                    });

                    // Add your onTap functionality here
                  },
                ),
                MyIconAndText(
                  imagePath: IconStrings.location,
                  text: lang.translate(Strings.myAddresses),
                  fontSize: 16,
                  onTap: () {
                    context.go("/${Routes.bottomNav}/${Routes.address}");
                    // Add your onTap functionality here
                  },
                ),
                MyIconAndText(
                  imagePath: IconStrings.share,
                  text: lang.translate(Strings.tellFriend),
                  fontSize: 16,
                  onTap: () {
                    Share.share('Look what i found in Opulencia APP!');
                    // Add your onTap functionality here
                  },
                ),
                MyIconAndText(
                  imagePath: IconStrings.setting,
                  text: lang.translate(Strings.settings),
                  fontSize: 16,
                  onTap: () {
                    context.go("/${Routes.bottomNav}/${Routes.setting}");
                    // Add your onTap functionality here
                  },
                ),
                MyIconAndText(
                  imagePath: IconStrings.edit,
                  text: lang.translate(Strings.customOrder),
                  fontSize: 16,
                  onTap: () {
                    context.go("/${Routes.bottomNav}/${Routes.customOrder}");
                  },
                ),
                // const MyDivider(),
                MyIconAndText(
                  imagePath: IconStrings.logout,
                  text: lang.translate(Strings.logout).toUpperCase(),
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  fontSize: 16,
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    // ignore: use_build_context_synchronously
                    context.go('/');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
