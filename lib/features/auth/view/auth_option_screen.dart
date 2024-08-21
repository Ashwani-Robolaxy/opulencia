import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/features/auth/controller/auth_controller.dart';
import 'package:opulencia/lang/delegates/localizations_delegate.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/icon_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:opulencia/utils/widgets/my_textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AuthOptionScreen extends ConsumerStatefulWidget {
  const AuthOptionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthOptionScreenState();
}

class _AuthOptionScreenState extends ConsumerState<AuthOptionScreen> {
  void _showCountryPicker() {
    final authData = ref.read(authControllerProvider);
    showCountryPicker(
      countryListTheme: CountryListThemeData(
          textStyle: Styles.mediumText(context),
          searchTextStyle: Styles.mediumText(context),
          inputDecoration: InputDecoration(
            hintStyle: Styles.mediumText(context).copyWith(
                color: Theme.of(context).canvasColor.withOpacity(0.4)),
            hintText: "Search Country",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.grey, width: 3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Styles.primary, width: 3),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.grey, width: 3),
            ),
          )),
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          print(country.phoneCode);
          authData.countryCode = country.phoneCode;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authData = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .translate(Strings.title)
                    .toUpperCase(),
                style: TextStyle(
                    fontSize: 40.0,
                    color: Theme.of(context).canvasColor,
                    fontFamily: Strings.appFont,
                    fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate(Strings.login),
                      style: Styles.largeBoldText(context).copyWith(
                          color: Theme.of(context).canvasColor, fontSize: 30),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(30),
                    width: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).canvasColor.withOpacity(0.06),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate(Strings.phoneNumber),
                            style: Styles.mediumText(context),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                _showCountryPicker();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xFF6E8596),
                                    )),
                                padding: const EdgeInsets.all(14),
                                child: Text(
                                  "+${authData.countryCode}",
                                  style: Styles.mediumText(context),
                                ),
                              ),
                            ),
                            const Gap(10),
                            Flexible(
                              child: MyTextField(
                                  maxLines: 1,
                                  maxLength: 10,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  title: AppLocalizations.of(context)!
                                      .translate(Strings.phoneNumber),
                                  hasTitle: false,
                                  controller: authData.phoneController,
                                  hintText: AppLocalizations.of(context)!
                                      .translate(Strings.phoneNumber)),
                            ),
                          ],
                        ),
                        const Gap(10),
                        MyCustomButton(
                            foregroundColor: Colors.white,
                            backgroundColor: Styles.primary,
                            onPressed: () async {
                              await authData.login(context);
                            },
                            label: AppLocalizations.of(context)!
                                .translate(Strings.sendOtp)),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Flexible(
                                    child: Divider(
                                  color: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(0.3),
                                )),
                                const Gap(10),
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate(Strings.or)
                                      .toUpperCase(),
                                  style: Styles.mediumText(context).copyWith(
                                      color: Theme.of(context).canvasColor),
                                ),
                                const Gap(10),
                                Flexible(
                                    child: Divider(
                                  color: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(0.3),
                                )),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              IconStrings.google,
                              height: 40,
                              color: Theme.of(context)
                                  .canvasColor
                                  .withOpacity(0.5),
                            ),
                            Image.asset(
                              IconStrings.fb,
                              height: 40,
                              color: Theme.of(context)
                                  .canvasColor
                                  .withOpacity(0.5),
                            ),
                            Image.asset(
                              IconStrings.apple,
                              height: 40,
                              color: Theme.of(context)
                                  .canvasColor
                                  .withOpacity(0.5),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(100),
            ],
          ),
        ),
      ),
    );
  }
}
