import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:amazon_clone_tutorial/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone_tutorial/features/admin/screens/analytics_screen.dart';
import 'package:amazon_clone_tutorial/features/home/screens/home_screen.dart';
import 'package:amazon_clone_tutorial/models/user.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/bottom_bar.dart';
import '../../../constants/global_variables.dart';
import '../../admin/screens/add_product_screen.dart';

class AuthService {
  // sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: "",
        name: name,
        email: email,
        password: password,
        address: "",
        type: "",
        token: "",
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackbar(
              context, "Account created! Login with the same credentials!");
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  // sign in user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: "",
        name: "",
        email: email,
        password: password,
        address: "",
        type: "",
        token: "",
        cart: [],
      );

      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; chartset=UTF-8'
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            var isAdmin = jsonDecode(res.body)['type'] == "admin";
            if (isAdmin) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AdminScreen.routeName,
                (route) => false,
              );
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                BottomBar.routeName,
                (route) => false,
              );
            }
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  // get user data
  void getUserData({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; chartset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        //get user data
        http.Response userRes = await http.get(Uri.parse('$uri/'),
            headers: <String, String>{
              'Content-Type': 'application/json; chartset=UTF-8',
              'x-auth-token': token
            });
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
