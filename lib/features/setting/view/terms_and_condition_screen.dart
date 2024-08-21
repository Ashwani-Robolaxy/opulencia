import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:opulencia/features/home/controller/home_controller.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';

class TermsAndConditionScreen extends ConsumerStatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState
    extends ConsumerState<TermsAndConditionScreen> {
  @override
  Widget build(BuildContext context) {
    var homeData = ref.watch(homeControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: "Terms and condtions"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HtmlWidget(
          homeData.termsAndCondtionsData,
          textStyle: Styles.mediumText(context),
        ),
      ),
    );
  }
}
