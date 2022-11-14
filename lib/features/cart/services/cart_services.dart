import 'dart:convert';
import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:amazon_clone_tutorial/models/product.dart';
import 'package:amazon_clone_tutorial/models/user.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../constants/global_variables.dart';

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
          Uri.parse('$uri/api/remove-from-cart/${product.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; chartset=UTF-8',
            'x-auth-token': userProvider.user.token,
          });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: (() {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.serUserFromModel(user);
        }),
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
