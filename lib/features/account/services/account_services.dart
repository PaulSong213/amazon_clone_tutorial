import 'dart:convert';

import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:amazon_clone_tutorial/features/account/widgets/orders.dart';
import 'package:amazon_clone_tutorial/models/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../../providers/user_provider.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/orders/me'), headers: {
        'Content-Type': 'application/json; chartset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      print(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            var order = Order.fromJson(jsonEncode(jsonDecode(res.body)[i]));
            orderList.add(order);
          }
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return orderList;
  }
}
