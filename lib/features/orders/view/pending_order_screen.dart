import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/utils/widgets/my_empty_message.dart';

class PendingOrderScreen extends ConsumerStatefulWidget {
  const PendingOrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PendingOrderScreenState();
}

class _PendingOrderScreenState extends ConsumerState<PendingOrderScreen> {
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
