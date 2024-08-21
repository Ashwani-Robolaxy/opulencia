import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:opulencia/features/home/controller/home_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';

class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    var homeData = ref.watch(homeControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: "Privacy Policy"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HtmlWidget(
          homeData.privacyData, // Render the HTML content

          textStyle: Styles.mediumText(context), // Apply your text style

          // webView: true, // Enable webview to render more complex HTML
          // hyperlinkColor: Theme.of(context).accentColor, // Color for hyperlinks
          // hyperlinkTap: (url, context, attributes, element) {
          //   // Handle tap on hyperlinks if needed
          // },
        ),
      ),
    );
  }
}
