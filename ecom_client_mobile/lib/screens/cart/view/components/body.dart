import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../models/Cart.dart';
import '../../../../size_config.dart';
import '../../../../user_list/view_models/user_view_model.dart';
import '../../view_model/cart_view_model.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    CartViewModel cartViweModel = context.watch<CartViewModel>();
    List<Cart> cartData = cartViweModel.getProductCart;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: cartData.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(cartData[index].product.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              cartViweModel.remoteItem(cartData[index].product);
              // setState(() {
              //   demoCarts.removeAt(index);
              // });
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  SvgPicture.asset("assets/icons/Trash.svg"),
                ],
              ),
            ),
            child: CartCard(cart: cartData[index]),
          ),
        ),
      ),
    );
  }
}
