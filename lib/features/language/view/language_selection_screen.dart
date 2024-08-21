import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
// Import your localizations delegate
import 'package:opulencia/main.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/route_strings.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart'; // Import your routes if needed

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  bool engSelected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: "语 Select Language"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLanguageTile(
                isSelected: engSelected,
                context: context,
                locale: const Locale('en', ''),
                language: 'English',
              ),
              const Gap(10),
              _buildLanguageTile(
                  isSelected: !engSelected,
                  context: context,
                  locale: const Locale('pt', ''),
                  language: 'Portuguese'),
              const Gap(10),
              MyCustomButton(
                  onPressed: () {
                    context.go('/${Routes.langSelection}/${Routes.authOption}');
                  },
                  label: "Continue")
            ],
          ),
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
      width: 100.w,
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
            // Update the engSelected flag
            engSelected = locale.languageCode == 'en';
          });
        },
      ),
    );
  }
}
