import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/models/models.dart';
import 'package:productos_app/models/personInfo.dart';
import 'package:productos_app/screens/product_screen.dart';
import 'package:productos_app/services/cloudinary_services.dart';
import 'package:productos_app/services/person_services.dart';


class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'product-varios-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;

  final storage = new FlutterSecureStorage();

  final cloudinaryService = new CloudDinaryServices();

  final PersonInfoServices personInfoServices = new PersonInfoServices();

  File? newPictureFile;
  late Person owner_product;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    this.loadProducts();
  }

  Future<List<Product>> loadProducts() async {

    this.isLoading = true;
    notifyListeners();
    
    final url = Uri.https( _baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.get( url );

    final Map<String, dynamic>? productsMap = json.decode( resp.body );

    if(productsMap!=null){
      productsMap.forEach((key, value) {
        print(value);
      final tempProduct = Product.fromMap( value );
      tempProduct.id = key;
      this.products.add( tempProduct );
    });
    }


    this.isLoading = false;
    notifyListeners();

    return this.products;

  }


  Future saveOrCreateProduct( Product product , String userID ) async {

    isSaving = true;
    notifyListeners();

    if ( product.id == null ) {
      // Es necesario crear
      await this.createProduct( product ,userID);
    } else {
      // Actualizar
      await this.updateProduct( product );
    }



    isSaving = false;
    notifyListeners();

  }
  

  Future<String> updateProduct( Product product ) async {
    final url = Uri.https( _baseUrl, 'products/${ product.id }.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    print(product.toJson());
    final resp = await http.put( url, body: product.toJson() );
    final decodedData = resp.body;
    print(decodedData);

    //TODO: Actualizar el listado de productos
    final index = this.products.indexWhere((element) => element.id == product.id );
    this.products[index] = product;

    return product.id!;

  }

  Future<String> createProduct( Product product , String userID ) async {

    final url = Uri.https( _baseUrl, 'products.json',{
      'auth': await storage.read(key: 'token') ?? ''
    });
    product.personId = userID;
    final resp = await http.post( url, body: product.toJson() );
    final decodedData = json.decode( resp.body );

    product.id = decodedData['name'];

    this.products.add(product);
    

    return product.id!;

  }

  Product updateProductLikes(Product product,String userId){
        Product updatedProduct = product.copy();
      if(product.likes.length == 0 || product.likes.where((uid) => uid==userId).isEmpty){
        updatedProduct.likes.add(userId);
      }else{
        updatedProduct.likes.remove(userId);
      }
      return updatedProduct;
  } 


   Future<int> updateLikes( Product product , String userID ) async {

    final url = Uri.https( _baseUrl, 'products/${product.id}.json',{
      'auth': await storage.read(key: 'token') ?? ''
    });
    final productUpdated = updateProductLikes(product,userID);
    final resp = await http.put( url, body: productUpdated.toJson() );
    final decodedData = json.decode( resp.body );
    final index = this.products.indexWhere((element) => element.id == product.id );
    this.products[index]=productUpdated;
    notifyListeners();
    return productUpdated.likes.length ;
  }


  bool isInclude (Product product,String userId){
    return product.likes.where((uid) => uid==userId).isEmpty;
  }
  

  void updateSelectedProductImage( String path ) {

    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri( Uri(path: path) );

    notifyListeners();

  }

  Future<String?> uploadImage() async {

    if (  this.newPictureFile == null ) return null;

    this.isSaving = true;
    notifyListeners();

    final String? imageUrl = await cloudinaryService.uploadImage(this.newPictureFile!);
    if(imageUrl!=null){
      this.newPictureFile = null;
      return imageUrl;
      }else{
      return null;
    }
  }

}