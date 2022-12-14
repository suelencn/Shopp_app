import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/editProduct_page.dart';
import '../providers/productProvider.dart';
import '../widgets/userProduct_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsPage extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndsetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, child) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (ctx, i) => (Column(
                            children: [
                              UserProductItem(
                                productsData.items[i].id,
                                productsData.items[i].imageUrl,
                                productsData.items[i].title,
                              ),
                              const Divider(),
                            ],
                          )),
                          itemCount: productsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
