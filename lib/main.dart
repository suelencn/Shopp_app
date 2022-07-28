import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/productDetail_page.dart';

import '../pages/productsOverview_page.dart';
import './providers/productProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        home: ProductsOverviewPage(),
        routes: {ProductDetailPage.routeName: (ctx) => ProductDetailPage()},
      ),
    );
  }
}
