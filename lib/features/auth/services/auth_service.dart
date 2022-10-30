import 'dart:convert';

import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:amazon_clone_tutorial/features/home/screens/home_screen.dart';
import 'package:amazon_clone_tutorial/models/user.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/global_variables.dart';

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
          token: "");

      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; chartset=UTF-8'
          });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackbar(
                context, "Account created! Login with the same credentials!");
          });
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
          token: "");

      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; chartset=UTF-8'
          });
      print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreen.routeName,
              (route) => false,
            );
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
