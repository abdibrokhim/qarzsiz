import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:qarzsiz/components/shared/refreshable.dart';
import 'package:qarzsiz/screens/mainlayout/components/debt_card.dart';
import 'package:qarzsiz/screens/mainlayout/components/market_list.dart';
import 'package:qarzsiz/screens/profile/profile_screen.dart';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/store/app/app_state.dart';
import 'package:qarzsiz/store/app/app_store.dart';


class MainLayout extends StatefulWidget {

  const MainLayout({
    Key? key,
  }) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
  }


    void reFetchData()  {
          print('refetching market list');
        store.dispatch(FetchShopsWithDebtsAction(store.state.appState.userState.user!.uid));
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    reFetchData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }


  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<GlobalState>(context);

    var total = state.state.appState.userState.debtDetailList?.fold<double>(0, (previousValue, element) => 
    previousValue + element.debtDetail.quantity * double.parse(element.product.price)) ?? 0;

var unpaidTotal = state.state.appState.userState.debtDetailList
    ?.where((element) => !element.debtDetail.isPaid) // Filter for isPaid == false
    .fold<double>(0, (previousValue, element) =>
        previousValue + element.debtDetail.quantity * double.parse(element.product.price)) ?? 0;

// TODO: later on we will use this to show the debt distribution, among the shops
  //   var debtD = {

  // '0xff00bc56': 0.5,
  // '0xffB9DE6D': 0.3,
  // '0xff601875': 0.2,

  //               };

      return StoreConnector<GlobalState, UserState>(
        onInit: (app) {
          print('onInit');
          print('fetching market list');
          store.dispatch(FetchShopsWithDebtsAction(store.state.appState.userState.user!.uid));
        },
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {
          return 
        Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.menu_rounded),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_2_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
            ],
          ),
          body: Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 

          Padding(
              padding: const EdgeInsets.all(20),
              child:
          Column(
            children: [
              TotalDebtCard(
                totalDebt: total.toDouble(),
                // deptDistribution: debtD,
                unpaidDebt: unpaidTotal.toDouble(),
              ),
              const SizedBox(height: 32.0,),

                       userState.isMarketListLoading
            ? Center(child: SizedBox(
              child:const CircularProgressIndicator()))
            :
          Expanded(
            child: 
              const MarketGridWidget()
          )
            ],
          )
          )
          )
        );
        }
      );
  }
}
