import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/utils/widgets/my_empty_message.dart';

class CompletedOrderScreen extends ConsumerStatefulWidget {
  const CompletedOrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompletedOrderScreenState();
}

class _CompletedOrderScreenState extends ConsumerState<CompletedOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: EmptyStateMessage(
        animationAsset: "assets/lottie/sad.json",
        message: "No Order Found",
      ),
    );
  }
}
