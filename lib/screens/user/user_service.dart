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

  static Future<List<ShopModel>> fetchShopsWithDebts(String userId) async {
    print('Fetching shops with debts for user $userId');
    try {
      // Querying the DebtRecords collection for the given userId
      final debtRecordsQuery = FirebaseFirestore.instance.collection('debtRecords').where('user_id', isEqualTo: userId);
      final debtRecordsResult = await debtRecordsQuery.get();
      print('debtRecordsResult $debtRecordsResult');

      // Extracting the list of unique shop IDs from the debt records
      Set<String> shopIdSet = {};
      for (var record in debtRecordsResult.docs) {
        shopIdSet.add(record.data()['shop_id']);
      }

      print('shopIdSet $shopIdSet');

      // Querying the Shops collection for details on each shop
      final shopCollection = FirebaseFirestore.instance.collection('shop');
      List<ShopModel> shopsList = [];
      for (String shopId in shopIdSet) {
        var shopDoc = await shopCollection.doc(shopId).get();
        if (shopDoc.exists) {
          shopsList.add(ShopModel.fromJson(shopDoc.data() as Map<String, dynamic>));
        }
      }

      print("Shops with debts: $shopsList");
      return shopsList;
    } catch (e) {
      print("Error while fetching shops with debts: $e");
      return Future.error('Failed to fetch shops with debts');
    }
  }


static Future<List<DebtDetailWithProduct>> fetchDebtDetailsForShop(String userId, String shopId) async {
    print('Fetching debt details for shop $shopId for user $userId');
    try {
        // Step 1: Query DebtRecords for the given userId and shopId
        final debtRecordsCollection = FirebaseFirestore.instance.collection('debtRecords');
        final debtRecordsQuery = await debtRecordsCollection
            .where('user_id', isEqualTo: userId)
            .where('shop_id', isEqualTo: shopId)
            .get();

        List<DebtDetailWithProduct> debtDetailsWithProductList = [];
        // Step 2: For each DebtRecord, query its DebtDetails subcollection
        for (var debtRecordDoc in debtRecordsQuery.docs) {
            var debtDetailsSubCollection = debtRecordDoc.reference.collection('debtDetails');
            var debtDetailsQuery = await debtDetailsSubCollection.get();
            for (var debtDetailDoc in debtDetailsQuery.docs) {
                // Fetch the associated product using the product_id
                String productId = debtDetailDoc.data()['product_id'];
                var productDoc = await FirebaseFirestore.instance.collection('products').doc(productId).get();
                if (productDoc.exists) {
                    var productData = productDoc.data() as Map<String, dynamic>;
                    var product = ProductModel.fromJson(productData);

                    var debtDetailData = debtDetailDoc.data();
                    // Make sure to convert Timestamp to DateTime if necessary
                    if (debtDetailData['createdAt'] is Timestamp) {
                        debtDetailData['createdAt'] = (debtDetailData['createdAt'] as Timestamp).toDate();
                    }
                    var debtDetail = DebtDetail.fromJson(debtDetailData);

                    debtDetailsWithProductList.add(DebtDetailWithProduct(debtDetail: debtDetail, product: product));
                }
            }
        }

        print("Debt details with products for shop $shopId: $debtDetailsWithProductList");
        return debtDetailsWithProductList;
    } catch (e) {
        print("Error while fetching debt details with products for shop $shopId: $e");
        return Future.error('Failed to fetch debt details with products for shop $shopId');
    }
}



}
