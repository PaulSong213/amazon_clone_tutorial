import 'dart:convert';
import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../models/user.dart';

class AddressServices {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'address': address}),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: (() {
            User user = userProvider.user.copyWith(
              address: jsonDecode(res.body)['address'],
            );
            userProvider.serUserFromModel(user);
          }));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/order'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'address': address,
          'cart': userProvider.user.cart,
          'totalPrice': totalSum,
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: (() {
            showSnackbar(context, 'Your order has been placed!');
            User user = userProvider.user.copyWith(
              cart: [],
            );
            userProvider.serUserFromModel(user);
          }));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
