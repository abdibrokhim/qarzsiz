import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qarzsiz/screens/shop/shop_model.dart';
import 'package:qarzsiz/screens/single_shop_screen/components/product_list.dart';
import 'package:qarzsiz/screens/user/user_reducer.dart';
import 'package:qarzsiz/store/app/app_store.dart';
import 'package:qarzsiz/utils/constants.dart';

class MarketGridWidget extends StatefulWidget {

  const MarketGridWidget({
    Key? key,
  }) : super(key: key);

  @override
  _MarketGridWidgetState createState() => _MarketGridWidgetState();
}

class _MarketGridWidgetState extends State<MarketGridWidget> {

  TextEditingController searchController = TextEditingController();

    List<ShopModel> filteredShops = store.state.appState.userState.debList ?? [];

  @override
  Widget build(BuildContext context) {

      var state = StoreProvider.of<GlobalState>(context).state.appState.userState;
    
    

    return Column(
      children: [
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search Market',
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
                            onChanged: (String value) {
                              setState(() {
                                
                    // Filter the list of shops based on the search query
                    filteredShops = (state.debList ?? []).where((shop) {
                      return shop.name.toLowerCase().contains(value.toLowerCase());
                    }).toList();
                    // Update the UI
                    (context as Element).markNeedsBuild();
                              });
                  },
        ),
    ),
    const SizedBox(height: 32.0,),
    Expanded(child: 
        SingleChildScrollView(
      child:
    Wrap(
      spacing: 32,
      runSpacing: 16,
      children: List.generate(filteredShops.length, (index) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: 
          InkWell(
            onTap: () {
              store.dispatch(SelectShopAction(filteredShops[index]));
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ProductListWidget())
              );
            },
            child:
              Image.network(
                state.debList?[index].image ?? defaultPostImage,
                fit: BoxFit.cover,
              ),
          )
        );
      }),
      ),
      ),
    ),
          ],
    );

  }
}
