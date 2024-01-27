import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/store/app/app_store.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";
  
  
  const ProfileScreen({
    Key? key, 
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: IconButton(onPressed: () { 
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_rounded),)
        ),
        body: StoreConnector<GlobalState, UserState>(
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {
          return
        SingleChildScrollView(
          child: 
        Column(
          children: [
            const Text('Profile'),
          ],
        ),
      );
        }
        ),
    );
  }

}