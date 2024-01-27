import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qarzsiz/components/shared/error/cuctom_error_widget.dart';
import 'package:qarzsiz/screens/auth/components/google_provider.dart';
import 'package:qarzsiz/screens/auth/forgotpassword/forgot_password_screen.dart';
import 'package:qarzsiz/screens/auth/signup/signup_screen.dart';
import 'package:qarzsiz/screens/mainlayout/main_layout_screen.dart';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/store/app/app_store.dart';


class SignInScreen extends StatefulWidget {
  static String routeName = "/signIn";
  
  final VoidCallback? onSignUpRequested;
  final VoidCallback? onForgotPasswordRequested;
  
  const SignInScreen({
    Key? key, 
    this.onSignUpRequested,
    this.onForgotPasswordRequested,
  }) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _performLogin() async {
    print('Performing login.');

    if (_emailController.text.isEmpty) {
      addError(error: 'Email is required');
      return;
    }
    if (_passwordController.text.isEmpty) {
      addError(error: 'Password is required');
      return;
    }
    
    StoreProvider.of<GlobalState>(context).dispatch(
      LoginAction(_emailController.text, _passwordController.text),
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

  bool showOnce = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: StoreConnector<GlobalState, UserState>(
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {
          return SingleChildScrollView(
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
                  onPressed: _performLogin,
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 20,),
                const Text('OR'),
                const SizedBox(height: 20,),
                SizedBox(
                  width: 300,
child:
                const SignInWithGoogleWidget(),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('I don\'t have an account, lemme '),
                    TextButton(
                      onPressed: () {
                                                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('I forgot my password, lemme '),
                    TextButton(
                      onPressed: () {
                                          Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                  );
                      },
                      child: const Text('Reset Password'),
                    ),
                  ],
                )
              ],
            ),
            ),
          );
        },
        onDidChange: (prev, next) {
          if (next.isLoggedIn && next.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainLayout()),
            );
          }
        },
        onDispose: (store) {},
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
