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
  final List<DebtDetailWithProduct>? debtDetailList;
  final List<ShopModel>? debList;
  final ShopModel? selectedShop;
  final bool isDebtDetailLoading;

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
    this.debtDetailList,
    this.debList,
    this.selectedShop,
    this.isDebtDetailLoading = false,
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
    List<DebtDetailWithProduct>? debtDetailList,
    List<ShopModel>? debList,
    ShopModel? selectedShop,
    bool? isDebtDetailLoading,
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
      debtDetailList: debtDetailList ?? this.debtDetailList,
      debList: debList ?? this.debList,
      selectedShop: selectedShop ?? this.selectedShop,
      isDebtDetailLoading: isDebtDetailLoading ?? this.isDebtDetailLoading,
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


// ========== FetchShopsWithDebtsAction reducers ========== //

class FetchShopsWithDebtsAction {
  final String userId;
  FetchShopsWithDebtsAction(this.userId);
}

UserState fetchMarketListActionReducer(UserState state, FetchShopsWithDebtsAction action) {
  return state.copyWith(isMarketListLoading: true);
}

class FetchShopsWithDebtsResponse {
  List<ShopModel> debList;

  FetchShopsWithDebtsResponse(this.debList);
}

UserState fetchMarketListSuccessReducer(UserState state, FetchShopsWithDebtsResponse action) {
  return state.copyWith(
    isMarketListLoading: false,
    debList: action.debList,
  );
}


// ========== FetchDebtDetailsForShopAction reducers ========== //


class FetchDebtDetailsForShopAction {
  String userId;
  String shopId;

  FetchDebtDetailsForShopAction(this.userId, this.shopId);
}

UserState fetchUserMarketListActionReducer(UserState state, FetchDebtDetailsForShopAction action) {
  return state.copyWith(isDebtDetailLoading: true);
}

class FetchDebtDetailsForShopResponse {
  List<DebtDetailWithProduct> debtDetailList;

  FetchDebtDetailsForShopResponse(this.debtDetailList);
}

UserState fetchUserMarketListSuccessReducer(UserState state, FetchDebtDetailsForShopResponse action) {
  return state.copyWith(
    isDebtDetailLoading: false,
    debtDetailList: action.debtDetailList,
  );
}


class SelectShopAction {
  ShopModel shop;

  SelectShopAction(this.shop);
}


UserState selectShopReducer(UserState state, SelectShopAction action) {
  return state.copyWith(
    selectedShop: action.shop,
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
  TypedReducer<UserState, FetchShopsWithDebtsAction>(fetchMarketListActionReducer),
  TypedReducer<UserState, FetchShopsWithDebtsResponse>(fetchMarketListSuccessReducer),
  TypedReducer<UserState, FetchDebtDetailsForShopAction>(fetchUserMarketListActionReducer),
  TypedReducer<UserState, FetchDebtDetailsForShopResponse>(fetchUserMarketListSuccessReducer),
  TypedReducer<UserState, SelectShopAction>(selectShopReducer),
]);