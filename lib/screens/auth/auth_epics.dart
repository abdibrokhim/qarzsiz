import 'dart:async';
import 'package:qarzsiz/screens/auth/firebase_auth_service.dart';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/store/app/app_store.dart';
import 'package:qarzsiz/utils/error_reducer.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';


// ========== Login Epics ========== //

Stream<dynamic> loginEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is LoginAction) 
      .asyncMap((action) => FirebaseAuthService.signInWithEmailAndPassword(action.username, action.password))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            LoginSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while logging in'),
          ]));
}


// ========== SignUp Epics ========== //

Stream<dynamic> signUpEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SignUpAction) 
      .asyncMap((action) => FirebaseAuthService.signUpWithEmailAndPassword(action.email, action.password,))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SignUpResponseAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while signing up'),
          ]));
}


// ========== LogOut Epics ========== //


Stream<dynamic> logOutEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is LogOutAction) 
      .asyncMap((action) => FirebaseAuthService.signOut())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            LogOutSuccessAction(),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while logging out'),
          ]));
}


Stream<dynamic> googleAuthEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SignInWithGoogle) 
      .asyncMap((action) => FirebaseAuthService.signInWithGoogle())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SignInWithGoogleSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while signing in with google'),
          ]));
}



List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> authEffects = [
  loginEpic,
  signUpEpic,
  logOutEpic,
  googleAuthEpic
];
