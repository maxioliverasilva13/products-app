import 'package:flutter/material.dart';
import 'package:productos_app/models/comments.dart';
import 'package:productos_app/providers/comments_provider.dart';
import 'package:productos_app/screens/product_screen.dart';
import 'package:productos_app/services/person_services.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  const CommentItem({Key? key,required this.comment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
  print(comment.rate);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.0,left:10.0),
              width: double.infinity,
              child: Row(
                children: [
                  ClipRRect(
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Text("Maximiliano Olivera",style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w600),),
                  Expanded(child: Container()),
                  Text(comment.date,style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w600,color: Colors.grey),),
                  SizedBox(width: 15.0,)
                ],
              ),
            ),
            GetStarts(rate: comment.rate,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
              child: Text(comment.comment,maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w600,color: Colors.grey[800]),)),
          ],
        ),
      ),
    );
  }
}



class GetStarts extends StatelessWidget {
  final int rate;
  const GetStarts({Key? key,required this.rate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        height: 30,
        child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context,int i){
              if(i+1>rate){
                return Icon(Icons.star_border_sharp,color: Colors.grey,);
              }else{
                return Icon(Icons.star,color: Colors.yellow,);
              }
            },
          ),
      ),
    );
  }
}







class DynamicStarts extends StatefulWidget {
  const DynamicStarts({Key? key}) : super(key: key);

  @override
  State<DynamicStarts> createState() => _DynamicStartsState();
}

class _DynamicStartsState extends State<DynamicStarts> {
  int selectedRate = 0;

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        height: 30,
        child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context,int i){
             return GestureDetector(
               onTap: (){
                 setState(() {
                   this.selectedRate=i+1;
                 });
                 commentsProvider.commentEdit!.rate=i+1;
               },
                child: (i+1>selectedRate) ?
                 Icon(Icons.star_border_sharp,color: Colors.grey,) :
                 Icon(Icons.star,color: Colors.yellow,)
              
              );

              
            },
          ),
      ),
    );
  }
}


class CreateComment extends StatelessWidget {
  const CreateComment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsProvider>(context);
    final personProvider = Provider.of<PersonInfoServices>(context);
    final productService = Provider.of<ProductsService>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            DynamicStarts(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                  initialValue: commentsProvider.commentEdit!.comment,
                  onChanged: (value){
                    commentsProvider.commentEdit!.comment=value;
                  },
                  autocorrect: false,
                  obscureText: false,
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "Enter your comment here",
                   enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                  ),
                  ),
                ),
            ),
              SizedBox(height: 10.0,),
              MaterialButton(onPressed: () async {
                final DateTime now = DateTime.now();
                final date = "${now.day.toString()}/${now.month.toString()}/${now.year.toString()}";
                commentsProvider.commentEdit!.date=date;
                commentsProvider.commentEdit!.uid = personProvider.personActive.id;
                productService.selectedProduct.comments=commentsProvider.comments;
                commentsProvider.AddComment();
                await productService.saveOrCreateProduct(productService.selectedProduct,personProvider.personActive.id!);
              },
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                child: Text("Comentar",
                  style: TextStyle( color: Colors.white ),
                )
              ),
              )
    
          ],
        ),
      ),
    );
  }
}