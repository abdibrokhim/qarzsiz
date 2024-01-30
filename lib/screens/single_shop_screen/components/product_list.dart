import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:qarzsiz/components/shared/refreshable.dart';
import 'package:qarzsiz/screens/shop/shop_model.dart';
import 'package:qarzsiz/screens/single_shop_screen/components/debt_card.dart';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/store/app/app_store.dart';
import 'package:qarzsiz/utils/constants.dart';
import 'package:intl/intl.dart';

class ProductListWidget extends StatefulWidget {

  const ProductListWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  TextEditingController searchController = TextEditingController();

  List<DebtDetailWithProduct> filter = store.state.appState.userState.debtDetailList ?? [];


  @override
  void initState() {
    super.initState();
  }


    void reFetchData()  {
          var state = StoreProvider.of<GlobalState>(context).state.appState.userState;

          print('refetching market list');
                if (state.selectedShop != null) {
          store.dispatch(FetchDebtDetailsForShopAction(store.state.appState.userState.user!.uid, state.selectedShop!.id));
        }
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
    print('i am rebuilding product list');

      var state = StoreProvider.of<GlobalState>(context).state.appState.userState;
    

    return StoreConnector<GlobalState, UserState>(
      onInit: (app) {
        print('init');
        if (state.selectedShop != null) {
          store.dispatch(FetchDebtDetailsForShopAction(store.state.appState.userState.user!.uid, state.selectedShop!.id));
        }
      },
        converter: (store) => store.state.appState.userState,
        builder: (context, state) {
          return
    Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Handle navigation back to the previous screen
          },
        ),
      ),
      body:                  Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
       Padding(
              padding: const EdgeInsets.all(20),
              child:
    Column(
      children: [
          state.isDebtDetailLoading
            ? Center(child: SizedBox(
              child:const CircularProgressIndicator()))
            :
        TotalDeptWidget(
          totalDept: state.debtDetailList!.fold(0, (previousValue, element) => previousValue + element.debtDetail.quantity * double.parse(element.product.price)),
          shopName: state.selectedShop!.name,
          imageUrl: state.selectedShop!.image,
        ),
        const SizedBox(height: 32.0,),
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search Product',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
                            onChanged: (String value) {
                              setState(() {
                                
                    // Filter the list of shops based on the search query
                    filter = (state.debtDetailList! ?? []).where((product) {
                      return product.product.name.toLowerCase().contains(value.toLowerCase());
                      // product.product.price.toLowerCase().contains(value.toLowerCase()) ||
                      // product.debtDetail.createdAt.toString().contains(value.toLowerCase());
                    }).toList();
                    // Update the UI
                    (context as Element).markNeedsBuild();
                              });
                  },
        ),
    ),
    const SizedBox(height: 32.0,),
    state.isDebtDetailLoading
            ? Center(child: SizedBox(
              child:const CircularProgressIndicator()))
            :
    Expanded(
  child: ListView.builder(
    itemCount: state.debtDetailList!.length,
    itemBuilder: (context, index) {
      final debt = state.debtDetailList![index];
      
      // Assuming that the price string is a valid double, e.g. '10.50'
      double price = double.tryParse(debt.product.price) ?? 0.0;

      // Now you can multiply the quantity with the price
      String totalPrice = (debt.debtDetail.quantity * price).toStringAsFixed(2); // Formats the result to 2 decimal places
      String itemName = debt.product.name;
      return Card(
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.1),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          title: Text(
            '${NumberFormat('#,##0').format(double.parse(totalPrice))} UZS, ${itemName.toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(DateFormat('dd.MM.yyyy').format(debt!.debtDetail.createdAt)),
          trailing: Icon(
            Icons.square,
            // Assuming you have a boolean to check if the debt is paid
            color: debt.debtDetail.isPaid ? Colors.green : Colors.red,
          ),
          onTap: () {
            print('Tapped on debt $index');
            // Handle navigation to detail screen
          },
        ),
      );
    },
  ),
)

          ],
        ),
        ),
        ),
    );
        }
    );

  }
}
