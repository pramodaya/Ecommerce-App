import 'package:ecom_admin_app/screens/cart/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../components/default_button.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    CartViewModel cartViewModel = context.watch<CartViewModel>();
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: getProportionateScreenWidth(40),
                  width: getProportionateScreenWidth(40),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset("assets/icons/receipt.svg"),
                ),
                Spacer(),
                Text("Add voucher code"),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kTextColor,
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\$" + cartViewModel.getTotalPrice.toString(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Check Out",
                    press: () {
                      makePayment(cartViewModel, (cartViewModel.getTotalPrice* 100).toString());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(CartViewModel cartViweModel, String price) async {
    final uri = Uri.parse(
        'https://us-central1-fiver-ecom-app.cloudfunctions.net/api/stripePayment');
    final headers = {'Content-Type': 'application/json'};
    Map<String, String> body = {"price": price};
    String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');

    // final url = Uri.http('', '/stripePayment');
    // final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    // // final response =
    // //     await http.get(url, headers: {'Content-Type': 'application/json'});

    // final response = await post(url,
    //     headers: {'Content-Type': 'application/json'}, body: body);

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      // encoding: encoding,
    );

    paymentIntentData = json.decode(response.body);
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
      applePay: true,
      googlePay: true,
      style: ThemeMode.light,
      merchantCountryCode: 'US',
      merchantDisplayName: 'Pramodaya',
    ));
    setState(() {});
    displayPaymentSheet(cartViweModel);
  }

  Future<void> displayPaymentSheet(CartViewModel cartViewModel) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // parameters: PresentPaymentSheetParameters(
      //         clientSecret: paymentIntentData!['paymentIntent'],
      //         confirmPayment: true)
      setState(() {
        paymentIntentData = null;
      });
      cartViewModel.clearCart();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Paid Successfully')));
    } catch (e) {
      print(e);
    }
  }
}
