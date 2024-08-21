import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/features/auth/controller/auth_controller.dart';
import 'package:opulencia/lang/delegates/localizations_delegate.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:opulencia/utils/toast/my_toast.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';

import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    var authData = ref.read(authControllerProvider);
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: myAppBar(context: context, title: ""),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(30),
                Text(
                  lang.translate(Strings.verificationCode),
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontSize: 34,
                    fontFamily: Strings.appFont,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const Gap(20),
                Text(
                  '${lang.translate(Strings.codeSent)} +${authData.countryCode} ${authData.phoneController.text}',
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontSize: 16,
                    fontFamily: Strings.appFont,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                const Gap(60),
                Pinput(
                  length: 4,
                  defaultPinTheme: authData.defaultPinTheme(context),
                  focusedPinTheme: authData.focusedPinTheme(context),
                  submittedPinTheme: authData.submittedPinTheme(context),
                  // validator: (s) {
                  //   // return null;

                  //   return s == widget.otp ? null : 'Pin is incorrect';
                  // },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onChanged: (value) {
                    authData.userOtp = value;
                    setState(() {});
                  },
                  onCompleted: (pin) {
                    setState(() {
                      authData.userOtp = pin;
                    });
                  },
                ),
                const Gap(40),
                InkWell(
                  onTap: () async {
                    if (authData.userOtp == null || authData.userOtp!.isEmpty) {
                      MyToast.failToast("Field cannot be empty", context);
                    } else if (authData.userOtp!.length < 4) {
                      MyToast.failToast("OTP must be of 4 Digits!", context);
                    } else {
                      await authData.verifyPhone(context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 100.w,
                    height: 57,
                    decoration: ShapeDecoration(
                      color: Styles.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Text(
                      lang.translate(Strings.next),
                      style: TextStyle(
                        fontFamily: Strings.appFont,
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Gap(50),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: lang.translate(Strings.codeNotRecieved),
                        style: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: 15,
                          fontFamily: Strings.appFont,
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: 0.50,
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: const Color(0xFF707684),
                          fontSize: 15,
                          fontFamily: Strings.appFont,
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: 0.50,
                        ),
                      ),
                      TextSpan(
                        text: lang.translate(Strings.resend),
                        style: TextStyle(
                          color: const Color(0xD8FF3B3B),
                          fontSize: 15,
                          fontFamily: Strings.appFont,
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// Business
// Id: great12@gmail.com
// Pass: Password@123

// User
// Id: kamini@gmail.com
// Pass: Password@123