import 'package:frontend_chat/models/user_models.dart';

class SellModel {
  final String id;
  final UserModel owner;
  final List<String> images;
  final String name;
  final String description;
  final double price;
  final String createdAt;
  final String updatedAt;

  SellModel({
    required this.id,
    required this.owner,
    required this.images,
    required this.name,
    required this.description,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SellModel.fromJson(Map<String, dynamic> json) {
    return SellModel(
      id: json['_id'] ?? '',
      owner: UserModel.fromJson(json),
      images: List<String>.from(json['images'] ?? []),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] is String
          ? double.tryParse(json['price']) ?? 0.0
          : json['price'].toDouble(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Owner': owner.toJson(),
      'images': images,
      'name': name,
      'description': description,
      'price': price,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'SellModel(id: $id, owner: $owner, images: ${images.join(', ')}, name: $name, description: $description, price: $price, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class AllSellModel {
  final List<SellModel> data;

  AllSellModel({
    required this.data,
  });

  factory AllSellModel.fromJson(List<dynamic> list) {
    return AllSellModel(
      data: list.map((job) => SellModel.fromJson(job)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((job) => job.toJson()).toList(),
    };
  }
}
