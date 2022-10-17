import 'package:flutter/material.dart';
import 'package:productos_app/models/comments.dart';
import 'package:productos_app/screens/product_screen.dart';


class CommentsProvider extends ChangeNotifier {
   Comment? commentEdit;
  List<Comment>? comments = [];

  CommentsProvider(this.comments){
    this.commentEdit = new Comment(rate: 3, date: "", comment: "");
  }

  void AddComment(){
    comments!.map((e) => print(e.rate));
    this.comments!.add(this.commentEdit!);
    this.commentEdit = new Comment(rate: 3, date: "", comment: "");
    notifyListeners();
  }

}