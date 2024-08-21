import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/features/address/controller/address_controller.dart';
import 'package:opulencia/features/auth/controller/auth_controller.dart';
import 'package:opulencia/features/category/controller/cat_controller.dart';
import 'package:opulencia/features/explore/view/explore_screen.dart';
import 'package:opulencia/features/home/controller/home_controller.dart';
import 'package:opulencia/features/home/view/home_screen.dart';
import 'package:opulencia/features/orders/controller/order_controller.dart';
import 'package:opulencia/features/profile/view/profile_screen.dart';
import 'package:opulencia/lang/delegates/localizations_delegate.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/icon_strings.dart';
import 'package:opulencia/utils/strings/strings.dart';

class BottomNavScreen extends ConsumerStatefulWidget {
  const BottomNavScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomNavScreenState();
}

class _BottomNavScreenState extends ConsumerState<BottomNavScreen> {
  int _currentIndex = 0;
  fetchData() {
    setState(() {});
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: _buildBody(_currentIndex),
      bottomNavigationBar: Container(
        // decoration: BoxDecoration(
        //     border: BorderDirectional(
        //         top: BorderSide(
        //             width: 2, color: Styles.primary.withOpacity(0.1)))),
        child: BottomNavigationBar(
          elevation: 100,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: Theme.of(context).canvasColor,
          unselectedItemColor: Theme.of(context).canvasColor.withOpacity(0.5),
          unselectedLabelStyle: Styles.mediumText(context)
              .copyWith(fontSize: 14, color: Theme.of(context).canvasColor),
          selectedLabelStyle: Styles.mediumText(context).copyWith(
              fontSize: 14,
              color: Theme.of(context).canvasColor.withOpacity(0.5)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                IconStrings.home,
                height: 25,
                color: _currentIndex == 0
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).canvasColor.withOpacity(0.5),
              ),
              label: lang.translate(Strings.home),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                IconStrings.grid,
                height: 25,
                color: _currentIndex == 1
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).canvasColor.withOpacity(0.5),
              ),
              label: lang.translate(Strings.explore),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                IconStrings.profile,
                height: 25,
                color: _currentIndex == 2
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).canvasColor.withOpacity(0.5),
              ),
              label: lang.translate(Strings.profile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ExploreScreen();
      case 2:
        return const ProfileScreen();
      default:
        return Container();
    }
  }
}
