import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/store/app/app_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qarzsiz/utils/constants.dart';


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

    final User user = FirebaseAuth.instance.currentUser!;

    String photoUrl = user.photoURL ?? defaultProfileImage;
    String displayName = user.displayName ?? 'No Name';
    String email = user.email ?? 'No Email';

    return
      Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () { 
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_rounded),)
        ),
        body: StoreConnector<GlobalState, UserState>(
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(photoUrl),
              radius: 50.0, // Size of the profile image
            ),
            SizedBox(height: 10), // Spacing between elements
            Text(
              displayName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5), // Spacing between elements
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Expanded(child: SizedBox(),),
          ]
        ),
    );

        }
        ),
    );
  }

}