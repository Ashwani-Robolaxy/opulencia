import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:opulencia/features/home/controller/home_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';

class RefundPolicyScreen extends ConsumerStatefulWidget {
  const RefundPolicyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RefundPolicyScreenState();
}

class _RefundPolicyScreenState extends ConsumerState<RefundPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    var homeData = ref.watch(homeControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: "Refund Policy"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HtmlWidget(
          homeData.refundPolicyData, // Render the HTML content
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
