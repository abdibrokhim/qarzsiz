import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qarzsiz/screens/auth/signin/signin_screen.dart';
import 'package:qarzsiz/screens/mainlayout/main_layout_screen.dart';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/store/app/app_store.dart';


class Bridge extends StatelessWidget {
  const Bridge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, UserState>(
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {
          return userState.isLoggedIn ? const MainLayout() : const SignInScreen();
        }
    );
  }
}