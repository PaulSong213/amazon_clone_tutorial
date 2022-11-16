import 'dart:convert';
import 'dart:io';
import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:amazon_clone_tutorial/models/order.dart';
import 'package:amazon_clone_tutorial/models/product.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required int price,
    required int quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('dhv3phitc', 'pozc5pdj');
      List<String> imageUrls = [];

      for (var i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: (() {
            showSnackbar(context, 'Product added successfully');
            Navigator.pop(context);
          }));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  // get all the products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.post(Uri.parse('$uri/admin/get-products'), headers: {
        'Content-Type': 'application/json; chartset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            var product = Product.fromJson(jsonEncode(jsonDecode(res.body)[i]));
            productList.add(product);
          }
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return productList;
  }

  // get all the order
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-orders'), headers: {
        'Content-Type': 'application/json; chartset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

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

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': product.id}),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: (() {
            onSuccess();
          }));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void changeOrderStatus({
    required BuildContext context,
    required Order order,
    required int status,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: (() {
            onSuccess();
          }));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
