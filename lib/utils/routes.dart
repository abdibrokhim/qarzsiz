import 'package:flutter/material.dart';

class AppRoutes {
  static const String init = '/';
  static const String home = '/home';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String profile = '/profile';
  static const String singlePost = '/singleShop';
  static const String forgotPassword = '/forgotPassword';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      // home: (context) => const HomeScreen(),
      // signIn: (context) => const SignInScreen(),
      // signUp: (context) => const SignUpScreen(),
      // profile: (context) => const ProfileScreen(),
      // singlePost: (context) => const SingleShopScreen(),
      // forgotPassword:(context) => const ForgotPasswordScreen(),
    };
  }
}
