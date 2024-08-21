import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/orders/view/my_custom_orders_screen.dart';
import 'package:opulencia/features/orders/view/orders_screen.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';

class OrderTabScreen extends ConsumerStatefulWidget {
  const OrderTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderTabScreenState();
}

class _OrderTabScreenState extends ConsumerState<OrderTabScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        context: context,
        title: "My Orders",
      ),
      body: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: tabController,
            tabs: [
              Tab(
                child: Text(
                  'In-App',
                  style: Styles.mediumBoldText(context),
                ),
              ),
              Tab(
                child: Text(
                  'Custom',
                  style: Styles.mediumBoldText(context),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                OrdersScreen(),
                MyCustomOrderScreen(),
                // Center(
                //     child: EmptyStateMessage(
                //         message: "No Order Found!",
                //         animationAsset:
                //             "assets/lottie/sad.json")), // Placeholder for Custom Order content
              ],
            ),
          ),
        ],
      ),
    );
  }
}
