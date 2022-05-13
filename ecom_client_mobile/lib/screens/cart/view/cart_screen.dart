import 'package:ecom_admin_app/screens/cart/view/components/check_out_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/Cart.dart';
import '../view/components/body.dart';
import '../view_model/cart_view_model.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
      bottomNavigationBar: CheckoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    CartViewModel cartViewModel = context.watch<CartViewModel>();
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${cartViewModel.getProductCart.length} items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
