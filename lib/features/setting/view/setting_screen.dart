import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/main.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:opulencia/utils/widgets/my_header.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  bool engSelected = true; // Declare engSelected as a class member

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            MyHeader(
              text: 'Theme',
              removeViewAll: true,
            ),
            const Gap(10),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).canvasColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(
                  'Dark Theme',
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontSize: 18,
                    fontFamily: Strings.appFont,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Switch(
                  value: isDarkTheme,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).state = value;
                  },
                ),
              ),
            ),
            const Gap(10),
            MyHeader(
              text: 'Language',
              removeViewAll: true,
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLanguageTile(
                  isSelected: engSelected,
                  context: context,
                  locale: const Locale('en', ''),
                  language: 'English',
                ),
                _buildLanguageTile(
                  isSelected: !engSelected,
                  context: context,
                  locale: const Locale('pt', ''),
                  language: 'Portuguese',
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                context.go(
                    "/${Routes.bottomNav}/${Routes.setting}/${Routes.termsAndCondition}");
              },
              child: Container(
                width: 100.w,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 2,
                        color: Theme.of(context).canvasColor.withOpacity(0.3))),
                child: Text(
                  'Terms and Conditions',
                  style: Styles.mediumBoldText(context).copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).canvasColor.withOpacity(0.5)),
                ),
              ),
            ),
            const Gap(10),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                context.go(
                    "/${Routes.bottomNav}/${Routes.setting}/${Routes.privacy}");
              },
              child: Container(
                width: 100.w,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 2,
                        color: Theme.of(context).canvasColor.withOpacity(0.3))),
                child: Text(
                  'Privacy Policy',
                  style: Styles.mediumBoldText(context).copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).canvasColor.withOpacity(0.5)),
                ),
              ),
            ),
            const Gap(10),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                context.go(
                    "/${Routes.bottomNav}/${Routes.setting}/${Routes.refundPolicy}");
              },
              child: Container(
                width: 100.w,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 2,
                        color: Theme.of(context).canvasColor.withOpacity(0.3))),
                child: Text(
                  'Refund Policy',
                  style: Styles.mediumBoldText(context).copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).canvasColor.withOpacity(0.5)),
                ),
              ),
            ),
            const Gap(10),
            MyCustomButton(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                onPressed: () {
                  
                },
                label: "Delete Account")
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required Locale locale,
    required bool isSelected,
    required String language,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: isSelected ? 2 : 2,
          color: isSelected
              ? Theme.of(context).canvasColor.withOpacity(0.9)
              : Theme.of(context).canvasColor.withOpacity(0.2),
        ),
      ),
      width: 44.w,
      child: ListTile(
        dense: true,
        title: Text(
          language,
          style: Styles.mediumBoldText(context),
        ),
        selected: isSelected,
        selectedTileColor: Styles.primary.withOpacity(0.1),
        onTap: () {
          // Set the selected language
          ref.read(englishLanguageProvider.notifier).state =
              locale.languageCode == 'en';
          setState(() {
            engSelected = locale.languageCode == 'en';
          });
        },
      ),
    );
  }
}
