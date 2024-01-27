// import 'package:flutter/foundation.dart';
import 'package:qarzsiz/screens/auth/components/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qarzsiz/screens/shop/shop_model.dart';


class UserService {

  static Future<Map<String, String?>> getUserAccessToken() async {
    try {
      var tokens = await StorageService.readItemsFromToKeyChain();
        String accessToken = tokens['accessToken'] ?? '';
        String refreshToken = tokens['refreshToken'] ?? '';
        String userId = tokens['userId'] ?? '';
        if (accessToken == '' || refreshToken == '') {
          return {'accessToken': null, 'refreshToken': null, 'userId': null};
        }
        print({'accessToken': accessToken, 'refreshToken': refreshToken, 'userId': userId});
        return {'accessToken': accessToken, 'refreshToken': refreshToken, 'userId': userId};
    } catch (e) {
      print("error while fetching access token: $e");
      return Future.error('Failed to get user access token');
    }
  }

  static Future<List<ShopModel>> fetchShops(String userId) async {
    print('fetching shops');
    try {
      final debtList = FirebaseFirestore.instance.collection('user').doc(userId).collection('debt');
      final shopIdList = await debtList.get();
      print('shopIdList: $shopIdList');

      // fetch shops from shop collection where doc path is in shopIdList
      final shopCollection = FirebaseFirestore.instance.collection('shops');
      final shops = await shopCollection.where('__name__', whereIn: shopIdList.docs.map((e) => e.id).toList()).get();
      List<ShopModel> shopsList = [];
      for (var shop in shops.docs) {
        shopsList.add(ShopModel.fromJson(shop.data()));
      }
      print("shopsList: $shopsList");

      return shopsList;
    } catch (e) {
      print("error while fetching shops: $e");
      return Future.error('Failed to get shops');
    }
  }

  static Future<List<ShopModel>> fetchUserShps(String userId) async {
    print('fetching user shops');
    try {
      final shopCollection = FirebaseFirestore.instance.collection('user').doc(userId).collection('shops');
      final shops = await shopCollection.get();
      List<ShopModel> shopsList = [];
      for (var shop in shops.docs) {
        shopsList.add(ShopModel.fromJson(shop.data()));
      }
      print("shopsList: $shopsList");

      return shopsList;
    } catch (e) {
      print("error while fetching shops: $e");
      return Future.error('Failed to get shops');
    }
  }

}