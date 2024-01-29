import 'dart:async';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/screens/user/user_service.dart';
import 'package:qarzsiz/store/app/app_store.dart';
import 'package:qarzsiz/utils/error_reducer.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';


// Stream<dynamic> getUserAccessToken(Stream<dynamic> actions, EpicStore<GlobalState> store) {
//   return actions
//       .where((action) => action is GetUserAccessTokenAction)
//       .asyncMap((action) => UserService.getUserAccessToken())
//       .flatMap<dynamic>((value) => Stream.fromIterable([
//             GetUserAccessTokenSuccessAction(value),
//           ]))
//       .onErrorResume((error, stackTrace) => Stream.fromIterable([
//             HandleErrorGetUserByIdAction(),
//           ]));
// }


Stream<dynamic> fetchShopsWithDebtsEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FetchShopsWithDebtsAction)
      .asyncMap((action) => UserService.fetchShopsWithDebts(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FetchShopsWithDebtsResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching fetchShopsWithDebts'),
          ]));
}

Stream<dynamic> fetchDebtDetailsForShopEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FetchDebtDetailsForShopAction)
      .asyncMap((action) => UserService.fetchDebtDetailsForShop(action.userId, action.shopId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FetchDebtDetailsForShopResponse(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching fetchDebtDetailsForShop'),
          ]));
}


List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> userEffects = [
  // getUserAccessToken,
  fetchShopsWithDebtsEpic,
  fetchDebtDetailsForShopEpic,
];

