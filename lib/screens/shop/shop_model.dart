
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  final String id;
  final String name;
  final String image;
  final String description;
  final int rating;

  ShopModel({
    required this.id,
    required this.name, 
    required this.image, 
    required this.description, 
    required this.rating,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      rating: json['rating'],
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String image;
  final String description;
  final String price;
  final String shopId;
  final int total;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name, 
    required this.image, 
    required this.description, 
    required this.price,
    required this.shopId,
    required this.total,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    Timestamp? timestamp = json['createdAt'] as Timestamp?;
    DateTime? createdAt;
    if (timestamp != null) {
      createdAt = timestamp.toDate();
    }

    return ProductModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      price: json['price'],
      shopId: json['shop_id'],
      total: json['total'],
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}



class DebtRecord {
  final String id;
  final String userId;
  final String shopId;
  final DateTime createdAt;
  final String totalDebt;

  DebtRecord({
    required this.id,
    required this.userId, 
    required this.shopId, 
    required this.createdAt, 
    required this.totalDebt,
  });

  factory DebtRecord.fromJson(Map<String, dynamic> json) {
        Timestamp? timestamp = json['createdAt'] as Timestamp?;
    DateTime? createdAt;
    if (timestamp != null) {
      createdAt = timestamp.toDate();
    }
    return DebtRecord(
      id: json['id'],
      userId: json['user_id'],
      shopId: json['shop_id'],
      createdAt: createdAt ?? DateTime.now(),
      totalDebt: json['totalDebt'],
    );
  }
}

class DebtDetail {
  final String id;
  final String productId;
  final int quantity;
  final DateTime createdAt;
  final bool isPaid;

  DebtDetail({
    required this.id,
    required this.productId,
    required this.quantity, 
    required this.createdAt,
    required this.isPaid,
  });

  factory DebtDetail.fromJson(Map<String, dynamic> json) {
        Timestamp? timestamp = json['createdAt'] as Timestamp?;
    DateTime? createdAt;
    if (timestamp != null) {
      createdAt = timestamp.toDate();
    }
    return DebtDetail(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      createdAt: createdAt ?? DateTime.now(),
      isPaid: json['isPaid'],
    );
  }
}

class DebtDetailWithProduct {
    final DebtDetail debtDetail;
    final ProductModel product;

    DebtDetailWithProduct({
        required this.debtDetail,
        required this.product,
    });

    factory DebtDetailWithProduct.fromJson(Map<String, dynamic> json) {
        return DebtDetailWithProduct(
            debtDetail: json['debtDetail'],
            product: json['product'],
        );
    }
}


