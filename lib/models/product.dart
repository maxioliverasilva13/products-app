// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

import 'package:productos_app/models/comments.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/product_screen.dart';

class Product {
    Product({
        required this.available,
        required this.name,
        required this.personId,
        this.picture,
        required this.price,
        this.id,
        required this.likes,
        this.comments,
    });

    bool available;
    String name;
    String? picture;
    double price;
    String? id;
    String personId;
    List<dynamic> likes=[];
    List<Comment>? comments;

    factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    

    factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"].toDouble(),
        personId: json["personId"],
        likes: json["likes"] ,
        comments: Comment.resp(json["comments"]),
    );

    

    Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
        "personId": personId,
        "likes": likes ,
        "comments": comments!.map((e) => e.toMap()).toList(),
    };

    Product copy() => Product(
      available: this.available,
      name: this.name,
      picture: this.picture,
      price: this.price,
      id: this.id,
      personId: this.personId,
      likes: this.likes,
    );

}
