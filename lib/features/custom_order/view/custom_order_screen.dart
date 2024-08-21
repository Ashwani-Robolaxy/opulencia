import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/icon_strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomOrderScreen extends ConsumerStatefulWidget {
  const CustomOrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomOrderScreenState();
}

class _CustomOrderScreenState extends ConsumerState<CustomOrderScreen> {
  List<SocialModel> socialList = [
    SocialModel(
      iconUrl: IconStrings.call,
      titleText: "Call",
      subTitleText: "Feel free to call us!",
      color: Styles.blue,
      action: _launchCall,
    ),
    SocialModel(
      iconUrl: IconStrings.whatsapp,
      titleText: "WhatsApp",
      subTitleText: "Feel free to send us order on WhatsApp",
      color: Styles.greenColor,
      action: _launchWhatsApp,
    ),
    SocialModel(
      iconUrl: IconStrings.gmail,
      titleText: "Mail",
      subTitleText: "Feel free to send us order on mail",
      color: Styles.red,
      action: _launchMail,
    ),
  ];

  static void _launchCall() async {
    const url = 'tel:+1234567890'; // Replace with your phone number
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static void _launchWhatsApp() async {
    const phone = '+1234567890'; // Replace with your WhatsApp number
    const url = 'https://wa.me/$phone';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static void _launchMail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ashwani@robolaxy.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: "Custom Order"),
      body: Column(
        children: [
          ListView.separated(
              padding: const EdgeInsets.all(20),
              separatorBuilder: (context, index) {
                return const Gap(10);
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: socialList.length,
              itemBuilder: (context, index) {
                var socials = socialList[index];
                return CustomOrderWidget(
                  iconUrl: socials.iconUrl,
                  titleText: socials.titleText,
                  subTitleText: socials.subTitleText,
                  color: socials.color,
                  onTap: socials.action,
                );
              }),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomOrderWidget extends StatelessWidget {
  final String iconUrl;
  final String titleText;
  final String subTitleText;
  final Color? color;
  final VoidCallback onTap;

  const CustomOrderWidget({
    required this.iconUrl,
    required this.titleText,
    required this.subTitleText,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 100.w,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: color ?? Theme.of(context).canvasColor),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Image.asset(
              iconUrl,
              height: 40,
              width: 40,
              color: color ?? Theme.of(context).canvasColor,
            ),
            const Gap(20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: Styles.largeBoldText(context)
                      .copyWith(color: color ?? Theme.of(context).canvasColor)
                      .copyWith(height: 1.1),
                ),
                Text(
                  subTitleText,
                  style: Styles.smallText(context).copyWith(
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                      color: Theme.of(context).canvasColor.withOpacity(0.9)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SocialModel {
  final String iconUrl;
  final String titleText;
  final String subTitleText;
  final Color color;
  final VoidCallback action;

  SocialModel({
    required this.iconUrl,
    required this.titleText,
    required this.subTitleText,
    required this.color,
    required this.action,
  });
}
