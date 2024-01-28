class ShopModel {
  final String id;
  final String name;
  final String image;
  final String description;
  final String rating;
  final List<Product> products;

  ShopModel({
    required this.id,
    required this.name, 
    required this.image, 
    required this.description, 
    required this.rating,
    required this.products
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      rating: json['rating'],
      products: json['products'].map((product) => Product.fromJson(product)).toList(),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String image;
  final String description;
  final String price;

  Product({
    required this.id,
    required this.name, 
    required this.image, 
    required this.description, 
    required this.price
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      price: json['price'],
    );
  }
}


class UserDebtModel {
  final List<ShopModel> shops;
  final int amount;
  final bool isPaid;
  final DateTime createdAt;

  UserDebtModel({
    required this.shops,
    required this.amount,
    required this.isPaid,
    required this.createdAt
  });

  factory UserDebtModel.fromJson(Map<String, dynamic> json) {
    return UserDebtModel(
      shops: json['shops'].map((shop) => ShopModel.fromJson(shop)).toList(),
      amount: json['amount'],
      isPaid: json['isPaid'],
      createdAt: json['created_at'],
    );
  }
}


class UserDebtListModel {
  final List<UserDebtModel> userDebts;

  UserDebtListModel({
    required this.userDebts
  });

  factory UserDebtListModel.fromJson(Map<String, dynamic> json) {
    return UserDebtListModel(
      userDebts: json['userDebts'].map((userDebt) => UserDebtModel.fromJson(userDebt)).toList(),
    );
  }
}