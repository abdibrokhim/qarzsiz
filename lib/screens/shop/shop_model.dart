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


class UserShopModel {
  final String id;
  final List<Product> products;

  UserShopModel({
    required this.id,
    required this.products
  });

  factory UserShopModel.fromJson(Map<String, dynamic> json) {
    return UserShopModel(
      id: json['id'],
      products: json['products'].map((product) => Product.fromJson(product)).toList(),
    );
  }
}