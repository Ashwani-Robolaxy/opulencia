import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:lottie/lottie.dart';

class EmptyStateMessage extends StatelessWidget {
  final String message;
  final String animationAsset;

  const EmptyStateMessage({
    super.key,
    required this.message,
    required this.animationAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animationAsset, height: 20.h),
          Text(
            message,
            style: Styles.mediumText(context).copyWith(
                fontSize: 20,
                color: Theme.of(context).canvasColor.withOpacity(0.5)),
          ),
          const Gap(50),
        ],
      ),
    );
  }
}
