

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:productos_app/models/personInfo.dart';
import 'package:productos_app/services/cloudinary_services.dart';

class PersonToEditProvider extends ChangeNotifier {

  late Person actualPerson;
  late Person personToEdit = actualPerson.copy();
  File? newPictureFile;
  final cloudinaryService = new CloudDinaryServices();
  PersonToEditProvider(this.actualPerson){
    this.actualPerson = actualPerson;
  }
  bool isSaving = false;

  bool get hasDifference {
      return  personToEdit.email != actualPerson.email || personToEdit.photo != actualPerson.photo || personToEdit.city != actualPerson.city || personToEdit.country != actualPerson.country || personToEdit.name != actualPerson.name;
  }

  Widget get getPhoto{

    if(newPictureFile!=null){
      return Image.file(
      File( newPictureFile!.path ),
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    );
    }
    if(personToEdit.photo!=null){
     return FadeInImage(
        width: 120,
      height: 120,
          image: NetworkImage(personToEdit.photo!),
          placeholder: AssetImage('assets/jar-loading.gif'),
          fit: BoxFit.cover,
        );
    }
    return FadeInImage(
       width: 120,
      height: 120,
          image: NetworkImage("https://icon-library.com/images/no-user-image-icon/no-user-image-icon-0.jpg"),
          placeholder: AssetImage('assets/jar-loading.gif'),
          fit: BoxFit.cover,
        );
  }

  bool get isEditing{
    return this.newPictureFile!=null;
  }

  void updateSelectedImagePerson( String path ) {
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
      this.actualPerson.photo=imageUrl;
      this.personToEdit.photo=imageUrl;
      this.isSaving = false;
      notifyListeners();
      print(imageUrl);
      return imageUrl;
      }else{
      return null;
    }
  }

  void onChanged(){
    notifyListeners();
  }

}