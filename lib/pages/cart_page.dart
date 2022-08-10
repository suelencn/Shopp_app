import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import '../providers/orders.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart' as ci;

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartValues = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart, cartValues: cartValues)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: ((ctx, index) => ci.CartItem(
                  cartValues[index].id,
                  cart.items.keys.toList()[index],
                  cartValues[index].price,
                  cartValues[index].quantity,
                  cartValues[index].title,
                )),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  OrderButton({
    required this.cart,
    required this.cartValues,
  });

  final Cart cart;
  final List<CartItem> cartValues;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cartValues,
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      textColor: Theme.of(context).primaryColor,
      child: _isLoading ? CircularProgressIndicator() : const Text('ORDER NOW'),
    );
  }
}
