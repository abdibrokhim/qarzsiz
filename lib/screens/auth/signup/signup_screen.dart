import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qarzsiz/components/shared/error/cuctom_error_widget.dart';
import 'package:qarzsiz/screens/auth/signin/signin_screen.dart';
import 'package:qarzsiz/screens/mainlayout/main_layout_screen.dart';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/store/app/app_store.dart';


class SignUpScreen extends StatefulWidget {
  static const String routeName = "/signUp";

  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _performSignUp() {
        if (_emailController.text.isEmpty) {
      addError(error: 'Email is required');
      return;
    }
    if (_passwordController.text.isEmpty) {
      addError(error: 'Password is required');
      return;
    }
    StoreProvider.of<GlobalState>(context).dispatch(
      SignUpAction(_emailController.text, _passwordController.text),
    );
  }

    List<String> errors = [];

  @override
  void initState() {
    super.initState();

    initErrors();
  }


  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void initErrors() {
    setState(() {
      errors = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<GlobalState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: StoreConnector<GlobalState, UserState>(
        onDidChange: (prev, next) {
          if (next.isSignedUp) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainLayout()),
            );
          }
        },
              onInit: (store) {
              },
              converter: (store) => store.state.appState.userState,
              builder: (context, userState) {
                return
      SingleChildScrollView(
        child: Padding(
              padding: const EdgeInsets.all(20),
              child:
        Column(
          children: [
                                  const SizedBox(height: 20,),
                                  if (errors.isNotEmpty)
                      CustomErrorWidget(
                        errors: errors
                      ),
                      const SizedBox(height: 20,),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Email is required');
                }
              },
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Password is required');
                }
              },
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _performSignUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),
        ),
      );
              },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
