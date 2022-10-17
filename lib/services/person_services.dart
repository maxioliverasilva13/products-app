import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/models/models.dart';
import 'package:productos_app/models/personInfo.dart';
import 'package:productos_app/services/cloudinary_services.dart';


class PersonInfoServices extends ChangeNotifier {

  final String _baseUrl = 'product-varios-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Person personActive;
  String? personToRegisterPhotoPath=null;
  final cloudinaryService = new CloudDinaryServices();

  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  set updatePersonActive (Person personActiv){
    this.personActive = personActiv;
    notifyListeners();
  }

  Future<String> savePersonInfoServices( Person person ,String personId) async {

    final url = Uri.https( _baseUrl, 'people.json',{
      'auth': await storage.read(key: 'token') ?? ''
    });
    
    final resp = await http.patch(url, body: person.toJson(personId));
    final decodedData = json.decode( resp.body );
    this.personActive = person;

    this.newPictureFile=null;
    this.personToRegisterPhotoPath=null;
    return person.id!;
  }

    Future<String> updatePersonInfo( Person person) async {
      print(person.name);
    final url = Uri.https( _baseUrl, 'people/${person.id}.json',{
      'auth': await storage.read(key: 'token') ?? ''
    });
    
    final resp = await http.patch(url, body: person.normalToJson());
    final decodedData = json.decode( resp.body );
    this.personActive = person;
    this.newPictureFile=null;
    this.personToRegisterPhotoPath=null;
    notifyListeners();
    return person.id!;
  }

  

   Future<Person?> findPersonInfo( String personId ) async {
     if(personId==null){
       return null;
     }
    final url = Uri.https( _baseUrl, 'people/${personId}.json',{
      'auth': await storage.read(key: 'token') ?? '',
      'Content-Type': 'application/json',
      'Charset': 'utf-8'
    });
    
    final resp = await http.get( url);
    final decodedData = json.decode( resp.body );
    final Person person = Person.fromMap(decodedData);
    return person;
  }

  void updateSelectedImagePerson( String path ) {
    this.personToRegisterPhotoPath = path;
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
  

  String? getUrl (){
    if(this.newPictureFile==null){
      return null;
    }
    return this.personToRegisterPhotoPath;
  }

}