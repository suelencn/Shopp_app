import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../providers/productProvider.dart';
import '../pages/cart_page.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    //Essa abordagem funcionaria no lugar do didChangeDependencies,
    //mas é uma especie de "bug", não usar.
    // Future.delayed(Duration.zero).then((_) => {
    //   Provider.of<Products>(context).fetchAndsetProducts()
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndsetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Text('Only Favorite'),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text('Show all'),
              )
            ],
            icon: const Icon(
              Icons.more_vert,
            ),
            onSelected: (FilterOptions selectedValue) {
              setState(
                () {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                },
              );
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.itemCount.toString(),
              child: ch as Widget,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorites),
    );
  }
}
