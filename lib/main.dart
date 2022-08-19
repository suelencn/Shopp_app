import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './helpers/customRoutes.dart';
import './providers/auth.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/productProvider.dart';
import './pages/productDetail_page.dart';
import './pages/productsOverview_page.dart';
import './pages/cart_page.dart';
import './pages/orders_page.dart';
import './pages/userProducts_page.dart';
import './pages/editProduct_page.dart';
import './pages/auth_page.dart';
import './pages/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token ?? '',
            auth.userId ?? '',
            previousProducts == null ? [] : previousProducts.items,
          ),
          create: (ctx) => Products(
            null,
            '',
            [],
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token ?? '',
            auth.userId ?? '',
            previousOrders == null ? [] : previousOrders.orders,
          ),
          create: (ctx) => Orders(null, null, []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.deepOrange,
                accentColor: Colors.deepOrangeAccent,
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  },
                )),
            home: auth.isAuth
                ? ProductsOverviewPage()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResulSnapshot) =>
                        authResulSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashPage()
                            : AuthScreen()),
            //home: ProductsOverviewPage(),
            routes: {
              ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
              CartPage.routeName: (ctx) => CartPage(),
              OrdersPage.routeName: (ctx) => OrdersPage(),
              UserProductsPage.routeName: (ctx) => UserProductsPage(),
              EditProductPage.routeName: (ctx) => EditProductPage(),
            }),
      ),
    );
  }
}
