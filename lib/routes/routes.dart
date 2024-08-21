import 'package:go_router/go_router.dart';
import 'package:opulencia/features/address/view/add_address_screen.dart';
import 'package:opulencia/features/address/view/address_screen.dart';
import 'package:opulencia/features/auth/view/auth_option_screen.dart';
import 'package:opulencia/features/auth/view/otp_screen.dart';
import 'package:opulencia/features/bottom_nav/view/bottom_nav_screen.dart';
import 'package:opulencia/features/cart/view/cart_screen.dart';
import 'package:opulencia/features/cart/view/order_address_screen.dart';
import 'package:opulencia/features/category/model/sub_product_model.dart';
import 'package:opulencia/features/category/view/all_products_screen.dart';
import 'package:opulencia/features/category/view/category_screen.dart';
import 'package:opulencia/features/category/view/my_all_products_screen.dart';
import 'package:opulencia/features/category/view/sub_category_screen.dart';
import 'package:opulencia/features/custom_order/view/custom_order_screen.dart';
import 'package:opulencia/features/error/view/error_screen.dart';
import 'package:opulencia/features/favorite/view/favorite_screen.dart';
import 'package:opulencia/features/language/view/language_selection_screen.dart';
import 'package:opulencia/features/orders/model/custom_order_model.dart';
import 'package:opulencia/features/orders/model/order_history_model.dart';
import 'package:opulencia/features/orders/view/custom_order_items_screen.dart';
import 'package:opulencia/features/orders/view/order_items_screen.dart';
import 'package:opulencia/features/orders/view/order_tab_screen.dart';
import 'package:opulencia/features/product/view/common_product_detail_screen.dart';
import 'package:opulencia/features/product/view/product_detail.dart';
import 'package:opulencia/features/profile/view/edit_profile_screen.dart';
import 'package:opulencia/features/rating/view/rating_screen.dart';
import 'package:opulencia/features/search/view/search_screen.dart';
import 'package:opulencia/features/setting/view/privacy_policy_screen.dart';
import 'package:opulencia/features/setting/view/refund_policy_screen.dart';
import 'package:opulencia/features/setting/view/setting_screen.dart';
import 'package:opulencia/features/setting/view/terms_and_condition_screen.dart';
import 'package:opulencia/features/splash/view/splash_screen.dart';
import 'package:opulencia/utils/strings/route_strings.dart';

final GoRouter myRoutes = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
        path: '/${Routes.langSelection}',
        builder: (context, state) => const LanguageSelectionScreen(),
        routes: [
          GoRoute(
              path: Routes.authOption,
              builder: (context, state) => const AuthOptionScreen(),
              routes: [
                GoRoute(
                    path: Routes.otpVerify,
                    builder: (context, state) => const OtpVerificationScreen(),
                    routes: [
                      GoRoute(
                        path: Routes.bottomNav,
                        builder: (context, state) => const BottomNavScreen(),
                      ),
                    ]),
              ]),
        ]),
    GoRoute(
      path: "/${Routes.bottomNav}",
      builder: (context, state) => const BottomNavScreen(),
      routes: [
        GoRoute(
            path: Routes.myAllProducts,
            builder: (context, state) => MyAllProductsScreen(
                  productList: state.extra as List<SubProductDetail>,
                ),
            routes: [
              GoRoute(
                  path: Routes.commonProductDetail,
                  builder: (context, state) => CommonProductDetail(
                        productDetailData: state.extra as SubProductDetail,
                      ),
                  routes: [
                    GoRoute(
                        path: Routes.cart,
                        builder: (context, state) => const CartScreen(),
                        routes: [
                          GoRoute(
                              path: Routes.address,
                              builder: (context, state) =>
                                  const AddressScreen(),
                              routes: [
                                GoRoute(
                                  path: Routes.addAddress,
                                  builder: (context, state) =>
                                      const AddAddressScreen(),
                                ),
                              ]),
                        ]),
                  ]),
            ]),
        GoRoute(
            path: Routes.search,
            builder: (context, state) => const SearchScreen(),
            routes: [
              GoRoute(
                  path: Routes.commonProductDetail,
                  builder: (context, state) {
                    final productDetailData = state.extra as SubProductDetail?;
                    if (productDetailData == null) {
                      // Handle the error, maybe navigate back or show an error screen
                      return const ErrorScreen(); // Replace with your error screen
                    }
                    return CommonProductDetail(
                      productDetailData: productDetailData,
                    );
                  },
                  routes: [
                    GoRoute(
                        path: Routes.cart,
                        builder: (context, state) => const CartScreen(),
                        routes: [
                          GoRoute(
                              path: Routes.address,
                              builder: (context, state) =>
                                  const AddressScreen(),
                              routes: [
                                GoRoute(
                                  path: Routes.addAddress,
                                  builder: (context, state) =>
                                      const AddAddressScreen(),
                                ),
                              ]),
                        ]),
                  ]),
            ]),
        GoRoute(
            path: Routes.commonProductDetail,
            builder: (context, state) => CommonProductDetail(
                  productDetailData: state.extra as SubProductDetail,
                ),
            routes: [
              GoRoute(
                  path: Routes.cart,
                  builder: (context, state) => const CartScreen(),
                  routes: [
                    GoRoute(
                        path: Routes.address,
                        builder: (context, state) => const AddressScreen(),
                        routes: [
                          GoRoute(
                            path: Routes.addAddress,
                            builder: (context, state) =>
                                const AddAddressScreen(),
                          ),
                        ]),
                  ]),
            ]),
        GoRoute(
            path: Routes.cart,
            builder: (context, state) => const CartScreen(),
            routes: [
              GoRoute(
                  path: Routes.orderaddress,
                  builder: (context, state) => const OrderAddressScreen(),
                  routes: [
                    GoRoute(
                      path: Routes.addAddress,
                      builder: (context, state) => const AddAddressScreen(),
                    ),
                  ]),
            ]),
        GoRoute(
            path: Routes.subCategory,
            builder: (context, state) => const SubCategoryScreen(),
            routes: [
              GoRoute(
                path: Routes.productDetail,
                builder: (context, state) => const ProductDetail(),
              ),
              GoRoute(
                  path: Routes.allProducts,
                  builder: (context, state) => const AllProductsScreen(),
                  routes: [
                    GoRoute(
                        path: Routes.productDetail,
                        builder: (context, state) => const ProductDetail(),
                        routes: [
                          GoRoute(
                              path: Routes.cart,
                              builder: (context, state) => const CartScreen(),
                              routes: [
                                GoRoute(
                                    path: Routes.address,
                                    builder: (context, state) =>
                                        const AddressScreen(),
                                    routes: [
                                      GoRoute(
                                        path: Routes.addAddress,
                                        builder: (context, state) =>
                                            const AddAddressScreen(),
                                      ),
                                    ]),
                              ]),
                        ]),
                  ]),
            ]),
        GoRoute(
            path: Routes.setting,
            builder: (context, state) => const SettingScreen(),
            routes: [
              GoRoute(
                path: Routes.termsAndCondition,
                builder: (context, state) => const TermsAndConditionScreen(),
              ),
              GoRoute(
                path: Routes.privacy,
                builder: (context, state) => const PrivacyPolicyScreen(),
              ),
              GoRoute(
                path: Routes.refundPolicy,
                builder: (context, state) => const RefundPolicyScreen(),
              ),
            ]),
        GoRoute(
            path: Routes.productDetail,
            builder: (context, state) => const ProductDetail(),
            routes: [
              GoRoute(
                  path: Routes.cart,
                  builder: (context, state) => const CartScreen(),
                  routes: [
                    GoRoute(
                        path: Routes.orderaddress,
                        builder: (context, state) => const OrderAddressScreen(),
                        routes: [
                          GoRoute(
                            path: Routes.addAddress,
                            builder: (context, state) =>
                                const AddAddressScreen(),
                          ),
                        ]),
                  ]),
            ]),
        GoRoute(
          path: Routes.editProfile,
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: Routes.favorite,
          builder: (context, state) => const FavoriteScreen(),
        ),
        GoRoute(
            path: Routes.category,
            builder: (context, state) => const CategoryScreen(),
            routes: [
              GoRoute(
                  path: Routes.subCategory,
                  builder: (context, state) => const SubCategoryScreen(),
                  routes: [
                    GoRoute(
                      path: Routes.productDetail,
                      builder: (context, state) => const ProductDetail(),
                    ),
                    GoRoute(
                        path: Routes.allProducts,
                        builder: (context, state) => const AllProductsScreen(),
                        routes: [
                          GoRoute(
                              path: Routes.productDetail,
                              builder: (context, state) =>
                                  const ProductDetail(),
                              routes: [
                                GoRoute(
                                  path: Routes.cart,
                                  builder: (context, state) =>
                                      const CartScreen(),
                                ),
                              ]),
                        ]),
                  ]),
            ]),
        GoRoute(
            path: Routes.orders,
            builder: (context, state) => const OrderTabScreen(),
            routes: [
              GoRoute(
                path: Routes.orderItems,
                builder: (context, state) => OrderItemsScreen(
                  product: state.extra as OrderDetails,
                ),
              ),
              GoRoute(
                path: Routes.myCustomOrderItems,
                builder: (context, state) => CustomOrderItemsScreen(
                  product: state.extra as CustomOrderList,
                ),
              ),
              GoRoute(
                path: Routes.rating,
                builder: (context, state) => RatingScreen(
                  product: state.extra as ProductDetails,
                ),
              ),
            ]),
        GoRoute(
          path: Routes.customOrder,
          builder: (context, state) => const CustomOrderScreen(),
        ),
        GoRoute(
            path: Routes.address,
            builder: (context, state) => const AddressScreen(),
            routes: [
              GoRoute(
                path: Routes.addAddress,
                builder: (context, state) => const AddAddressScreen(),
              ),
            ]),
      ],
    ),
  ],
);
