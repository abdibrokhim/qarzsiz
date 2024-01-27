import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qarzsiz/components/shared/error/cuctom_error_widget.dart';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/store/app/app_store.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = "/forgotPassword";
  
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _performForgotPassword() {
    print('Performing forgot password.');
    print('Not implemented yet.');
    print('You may back to sign in screen.');
            if (_emailController.text.isEmpty) {
      addError(error: 'Email is required');
      return;
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: StoreConnector<GlobalState, UserState>(
        converter: (store) => store.state.appState.userState,
        builder: (context, state) {
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
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: _performForgotPassword,
                  child: const Text('Submit'),
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
    super.dispose();
  }
}
