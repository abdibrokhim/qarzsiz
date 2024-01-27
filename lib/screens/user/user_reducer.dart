import 'package:qarzsiz/screens/shop/shop_model.dart';
import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';



class UserState {
  final bool isLoading;
  final bool isMarketListLoading;
  final bool isLoggedIn;
  final bool isSignedUp;
  final String? accessToken;
  final String? refreshToken;
  final String message;
  final List<String?> errors;
  final User? user;
  final List<ShopModel>? shopsList;
  final List<Product>? productList;

  UserState({
    this.isLoading = false,
    this.isMarketListLoading = false,
    this.isLoggedIn = false,
    this.isSignedUp = false,
    this.accessToken = '',
    this.refreshToken = '',
    this.message = '',
    this.errors = const [],
    this.user,
    this.shopsList,
    this.productList,
  });

  UserState copyWith({
    bool? isLoading,
    bool? isMarketListLoading,
    bool? isLoggedIn,
    bool? isSignedUp,
    String? accessToken,
    String? refreshToken,
    String? message,
    List<String?>? errors,
    User? user,
    List<ShopModel>? shopsList,
    List<Product>? productList,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      isMarketListLoading: isMarketListLoading ?? this.isMarketListLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isSignedUp: isSignedUp ?? this.isSignedUp,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      message: message ?? this.message,
      errors: errors ?? this.errors,
      user: user ?? this.user,
      shopsList: shopsList ?? this.shopsList,
      productList: productList ?? this.productList,
    );
  }
}


// ========== Get user access token reducers ========== //

class GetUserAccessTokenAction {
  GetUserAccessTokenAction();
}

UserState getUserAccessTokenActionReducer(UserState state, GetUserAccessTokenAction action) {
  return state.copyWith(isLoading: true);
}

class GetUserAccessTokenSuccessAction {
  Map<String, dynamic> tokens;

  GetUserAccessTokenSuccessAction(this.tokens);
}

UserState getUserAccessTokenSuccessReducer(UserState state, GetUserAccessTokenSuccessAction action) {
  if (action.tokens["accessToken"] != null && action.tokens['refreshToken'] != null && action.tokens['user'] != null) {
    return state.copyWith(
      isLoading: false,
      isLoggedIn: true,
      accessToken: action.tokens['accessToken'],
      refreshToken: action.tokens['refreshToken'],
      user: action.tokens['user'],
    );
  }
  return state.copyWith(
    isLoading: false,
    isLoggedIn: true,
  );
}

// ========== SignUp reducers ========== //

class SignUpAction {
  final String email;
  final String password;

  SignUpAction(
    this.email,
    this.password,
  );
}

class SignUpResponseAction {
  final User? user;
  
  SignUpResponseAction(this.user);
}

UserState signUpSuccessReducer(
  UserState state,
  SignUpResponseAction action,
) {
  return state.copyWith(
    isLoading: false,
    isSignedUp: true,
    user: action.user,
  );
}


// ========== Login reducers ========== //

class LoginAction {
  String email;
  String password;

  LoginAction(
    this.email,
    this.password,
  );
}


UserState loginReducer(UserState state, LoginAction action) {
  return state.copyWith(isLoading: true);
}

class LoginSuccessAction {
  final User? user;

  LoginSuccessAction(
    this.user,
  );
}

UserState loginSuccessReducer(UserState state, LoginSuccessAction action) {
  return state.copyWith(
    isLoggedIn: true, 
    isLoading: false,
    user: action.user,
  );
}



// ========== SignInWithGoogle reducers ========== //


class SignInWithGoogle {
  SignInWithGoogle();
}

UserState signInWithGoogleReducer(UserState state, SignInWithGoogle action) {
  return state.copyWith(isLoading: true);
}

class SignInWithGoogleSuccessAction {
  final User user;

  SignInWithGoogleSuccessAction(
    this.user,
  );
}

UserState signInWithGoogleSuccessReducer(UserState state, SignInWithGoogleSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    isLoggedIn: true,
    user: action.user,
  );
}


// ========== LogOut reducers ========== //

class LogOutAction {
  LogOutAction();
}

UserState logOutActionReducer(UserState state, LogOutAction action) {
  return state.copyWith(isLoading: true);
}

class LogOutSuccessAction {
  LogOutSuccessAction();
}

UserState logOutSuccessReducer(
    UserState state, LogOutSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    isLoggedIn: false,
  );
}


// ========== fetch market list reducers ========== //

class FetchMarketListAction {
  final String userId;
  FetchMarketListAction(this.userId);
}

UserState fetchMarketListActionReducer(UserState state, FetchMarketListAction action) {
  return state.copyWith(isMarketListLoading: true);
}

class FetchMarketListSuccessAction {
  List<ShopModel> shopsList;

  FetchMarketListSuccessAction(this.shopsList);
}

UserState fetchMarketListSuccessReducer(UserState state, FetchMarketListSuccessAction action) {
  return state.copyWith(
    isMarketListLoading: false,
    shopsList: action.shopsList,
  );
}


// ========== fetch user market list reducers ========== //


class FetchUserMarketListAction {
  String userId;

  FetchUserMarketListAction(this.userId);
}

UserState fetchUserMarketListActionReducer(UserState state, FetchUserMarketListAction action) {
  return state.copyWith(isLoading: true);
}

class FetchUserMarketListSuccessAction {
  List<ShopModel> shopsList;

  FetchUserMarketListSuccessAction(this.shopsList);
}

UserState fetchUserMarketListSuccessReducer(UserState state, FetchUserMarketListSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    shopsList: action.shopsList,
  );
}




// ========== Combine all reducers ========== //

Reducer<UserState> userReducer = combineReducers<UserState>([
  TypedReducer<UserState, SignInWithGoogle>(signInWithGoogleReducer),
  TypedReducer<UserState, SignInWithGoogleSuccessAction>(signInWithGoogleSuccessReducer),
  TypedReducer<UserState, SignUpResponseAction>(signUpSuccessReducer),
  TypedReducer<UserState, GetUserAccessTokenAction>(getUserAccessTokenActionReducer),
  TypedReducer<UserState, GetUserAccessTokenSuccessAction>(getUserAccessTokenSuccessReducer),
  TypedReducer<UserState, LogOutAction>(logOutActionReducer),
  TypedReducer<UserState, LogOutSuccessAction>(logOutSuccessReducer),
  TypedReducer<UserState, LoginAction>(loginReducer),
  TypedReducer<UserState, LoginSuccessAction>(loginSuccessReducer),
  TypedReducer<UserState, FetchMarketListAction>(fetchMarketListActionReducer),
  TypedReducer<UserState, FetchMarketListSuccessAction>(fetchMarketListSuccessReducer),
]);