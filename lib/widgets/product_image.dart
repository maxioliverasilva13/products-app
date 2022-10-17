import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {

  final String? url;
  final double width;
  final double height;
  final double radius;

  const ProductImage({
    Key? key, 
    required this.width,
    required this.height,
    this.url,
    required this.radius,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( left: 10, right: 10, top: 10 ),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: width,
        height: height,
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(radius) ),
            child: getImage(url)
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white38,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0,5)
      )
    ]
  );


  Widget getImage( String? picture ) {

    if ( picture == null ) 
      return Image(
          image: AssetImage('assets/no-image.png'),
          fit: BoxFit.cover,
        );

    if ( picture.startsWith('http') ) 
        return FadeInImage(
          image: NetworkImage( this.url! ),
          placeholder: AssetImage('assets/jar-loading.gif'),
          fit: BoxFit.cover,
        );


    return Image.file(
      File( picture ),
      fit: BoxFit.cover,
    );
  }

}