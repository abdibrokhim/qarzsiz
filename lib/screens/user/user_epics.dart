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


Stream<dynamic> fetchShopsEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FetchMarketListAction)
      .asyncMap((action) => UserService.fetchShops(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FetchMarketListSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching shops'),
          ]));
}

Stream<dynamic> fetchUserShopsEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is FetchUserMarketListAction)
      .asyncMap((action) => UserService.fetchUserShps(action.userId))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            FetchUserMarketListSuccessAction(value),
          ]))
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while fetching shops'),
          ]));
}


List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> userEffects = [
  // getUserAccessToken,
  fetchShopsEpic,
  fetchUserShopsEpic,
];

