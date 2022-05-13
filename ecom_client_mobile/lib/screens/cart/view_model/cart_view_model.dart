import 'package:ecom_admin_app/models/Cart.dart';
import 'package:flutter/material.dart';

import '../../../models/Product.dart';

class CartViewModel extends ChangeNotifier {
  bool _loading = false;
  List<Cart> _productCart = [];
  double _totalPrice = 0.0;

  bool get loading => _loading;
  List<Cart> get getProductCart => _productCart;
  double get getTotalPrice => _totalPrice;

  setLoading(bool loaidng) async {
    _loading = loaidng;
    notifyListeners();
  }

  addProductToCart(Product product) {
    setLoading(true);
    _totalPrice += product.price;

    if (_productCart.isEmpty) {
      _productCart.add(Cart(product: product, numOfItem: 1));
    } else {
      bool itemFount = false;
      _productCart.forEach((element) {
        if (element.product.id == product.id) {
          element.numOfItem++;
          itemFount = true;
        }
      });
      if (itemFount == false) {
        _productCart.add(Cart(product: product, numOfItem: 1));
      }
    }
    setLoading(false);
    return;
  }

  remoteItem(Product product) {
    setLoading(true);
    if (_totalPrice != 0) {
      _totalPrice -= product.price;
      setLoading(false);
    }
    if (!_productCart.isEmpty) {
      _productCart.forEach((element) {
        if (element.product.id == product.id && element.numOfItem > 1) {
          element.numOfItem--;
          setLoading(false);
          return;
        } else if (element.product == product && element.numOfItem == 1) {
          _productCart.remove(element);
          setLoading(false);
          return;
        }
      });
    }
  }
}
