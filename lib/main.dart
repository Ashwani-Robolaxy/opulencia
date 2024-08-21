import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:opulencia/features/cart/model/order_model.dart';
import 'package:opulencia/lang/delegates/localizations_delegate.dart';
import 'package:opulencia/routes/routes.dart';
import 'package:opulencia/theme/my_theme.dart';
import 'package:opulencia/utils/boxes/boxes.dart';
import 'package:opulencia/utils/strings/strings.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  //  *********** USER DATA ADAPTERS************
  Hive.registerAdapter(OrderModelAdapter());

  //  *********** BOXES ************

  orderBox = await Hive.openBox<OrderModel>('orderBox');
  await Hive.initFlutter();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

final themeProvider = StateProvider<bool>((ref) => false);
final englishLanguageProvider = StateProvider<bool>((ref) => true);

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);
    final isEnglishSelected = ref.watch(englishLanguageProvider);
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: MaterialApp.router(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          routerConfig: myRoutes,
          title: AppLocalizations.of(context)?.translate(Strings.title) ??
              'Opulencia',
          theme: isDarkTheme ? MyThemes.darkTheme : MyThemes.lightThemes,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: isEnglishSelected
              ? const Locale('en', '')
              : const Locale('pt', ''),
          supportedLocales: const [
            Locale('en', ''),
            Locale('pt', ''),
          ],
        ),
      );
    });
  }
}




// Name*
// Surname*
// Address*
// Custom / Alternative Address
// Contacts (Mobile* / e-mail)
// For the Address, the clients must be able to add Notes or a
// Address Reference, so that the delivery boy can
// know that it's close to a certain place




// 19 April
// Black , red and white
// Frame type-- Bordered and Borderless frame (Toggle at detail view)
// sizes will be different for border and borderless frames.
// Percentage OFF will be shown  at the side of Price
// Different Size --Diff Price


// 28x28
// 40x60
// 43x43
// Above are the Sizes for the Frames with boarders

// For the Address:
// - Province
// - City
// -Home Address
//Landmark


/*

20 May

Custom Order (Outside of app)
1. Via Whatsapp
2. Via Email
When user places the order via social medias,
Admin will add the custom order from user behalf and that
order will reflect in application.

Promo banner
-> Discounts, Promo Name, Category, Frame Type


Cat -> Sub Cat -> Products



3 June
Gmail <--> mail
Call as first option for custom order



New Order ---New Review --Same User
Different Tab for custom Order


Show Name -- after entering user ID

Custom Order --- Another Type - where admin 
can write in textfield custom order of customer

Separate custom Order in admin panel

Custom address at admin panel
\\\

25 JUNE
******** LINK APP ******
Designed whole firebase database architecture

******** MSA TV ******
1. Fixed special character bug in login and registeration
2. Fixed White screen error when tapping on favourite episode

******** OPULENCIA ******
1. Get Trending Frames Api
2. Get New in the market Frames Api
3. Fixed rating summary bug

26 JUNE
******** OPULENCIA ******
1. Get Banner API
2. Get Recent Order API

2 JULY
******** OPULENCIA ******
1. Privacy Policy API
2. Terms and condition API
3. Refund Policy API

******** LOAD MASTER APP ******
Build IOS Part

******** HOTEL APP ******
R & D on POS Thermal Printer

******** ECO POINT ******
Tried to run IOS Part


............23 June.............

Currency Representation
 20.250,99 AOA
 Twenty Thousand, Two Hundred and Fifty kwanzas and Ninety Nine Cents
Kwanzas can be presented as AOA 
can be presented as Kz.
Dot Will be shown after every 3 digits...
Kz. 20.250,99

***********Fixes********
Date Format ---> dd/mm/yyyy
Stars at product Detail is static (below Price)

*****We Print Opulencia******
Printing for all (Slogan)
SLOGAN

PT: Impressão para todos !
EN: Printing for everyone!

https://pngmaker.io/
https://claid.ai/

Upload
 |
Edit File
 |
Order 


3rd Type OF order --- Enhanced Image with frame
MDF--


geral.opulencia@gmail.com


*/







