// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

import 'package:productos_app/models/models.dart';

class Comment {
    Comment({
        this.uid,
        required this.rate,
        required this.date,
        required this.comment,

    });
    String date ;
    int rate;
    String comment;
    String? uid;

    factory Comment.fromJson(String str) => Comment.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        date: json["date"],
        rate: json["rate"],
        comment: json["comment"],
        uid: json["uid"],
    );

    static List<Comment>? resp(json){
      final Map<String, dynamic>? productsMap = json.decode(json);
      List<Comment> comments = [];

    if(productsMap!=null){
      productsMap.forEach((key, value) {
      final tempComment = Comment.fromMap( value );
       comments.add( tempComment );
    });
      return comments;
    }
    return [];
    }

    Map<String, dynamic> toMap() => {
        "date": date,
        "rate": rate,
        "uid": uid,
    };

    Comment copy() => Comment(
      date: this.date,
      rate: this.rate,
      comment: this.comment,
      uid: this.uid,
    );

}
