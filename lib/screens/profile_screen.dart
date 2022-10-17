import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/models/personInfo.dart';
import 'package:productos_app/providers/person_to_edit_provider.dart';
import 'package:productos_app/services/person_services.dart';
import 'package:productos_app/widgets/product_image.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/widgets/text_with_icon.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    final personProfileInfo = Provider.of<PersonInfoServices>(context);
    final Person personActive = personProfileInfo.personActive;
    return Scaffold(
      body:
      SingleChildScrollView(
        child: 
        ChangeNotifierProvider(
            create: (_) => PersonToEditProvider(personActive),
            child: Column(children: [
           ProfilePhoto(),
           ProfileInfo(),
         ],),
          ),
      ),
    );
  }
}


class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final personProfileInfo = Provider.of<PersonInfoServices>(context);
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: 300,
      child: Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.indigo,
        ),
        Positioned(
          left: (size.width / 2) -50,
          top: 200-50,
          child: 
          ImageSelector(),
        ),
      ],
    ),
    );
  }
}


class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    return PersonInfoEdit(); 
  }
}



class PersonInfoEdit extends StatefulWidget {
  
  const PersonInfoEdit({Key? key}) : super(key: key);

  @override
  State<PersonInfoEdit> createState() => _PersonInfoEditState();
}

class _PersonInfoEditState extends State<PersonInfoEdit> {
   bool edit = false;
  @override
  Widget build(BuildContext context) {
    final personEditProvider = Provider.of<PersonToEditProvider>(context);
        final personProfileInfo = Provider.of<PersonInfoServices>(context);
    final personActive = personEditProvider.actualPerson;
    final personToEdit = personEditProvider.personToEdit;
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 30.0),
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              SizedBox(height: 10.0,),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text("Informacion Personal",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black87,fontSize: 18.0),),
                     SizedBox(width: 3.0,),
                     IconButton(onPressed: (){
                  setState(() {
                    edit=!edit;
                    personEditProvider.onChanged();
                  });
                }, icon: Icon(Icons.mode_edit_outlined))

                  ],
                ),
                alignment: Alignment.topCenter,
              ),
              SizedBox(height: 10.0,),
             
              TextWithIconEdit(editable: edit , icono: Icons.text_fields,name: "Nombre",value:personToEdit.name, onChange: (value){
                personToEdit.name=value!;
                personEditProvider.onChanged();
              }, ),
              TextWithIconEdit(editable: edit , icono: Icons.location_city,name: "Pais",value:personToEdit.city, onChange: (value){
                personToEdit.city=value!;
                personEditProvider.onChanged();
              }, ),
              TextWithIconEdit(editable: edit , icono: Icons.location_pin,name: "Ciudad",value:personToEdit.country , onChange: (value){
                personToEdit.country=value!;
               personEditProvider.onChanged();
              },),
              TextWithIconEdit(editable: edit , icono: Icons.email,name: "Email",value:personToEdit.email , onChange: (value){
                personToEdit.email=value!;
                personEditProvider.onChanged();
              },),
              SizedBox(height: 40.0,),

              if(personEditProvider.hasDifference) Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                  padding: EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                  child: Text("Guardar",
                    style: TextStyle( color: Colors.white ),
                  )
                ),
                onPressed:() async {
                  final String id = await personProfileInfo.updatePersonInfo(personToEdit);
                  if(id!=null){
                    print(id);
                    setState(() {
                    edit=!edit;
                    personEditProvider.onChanged();
                  });
                 
                  }
                }
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}





class ImageSelector extends StatelessWidget {
  const ImageSelector({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
     final personEditProvider = Provider.of<PersonToEditProvider>(context);
     final personToEdit = personEditProvider.personToEdit;
    return Container(
      width: 120,
      height: 120,
      child:  ClipRRect(
               borderRadius: BorderRadius.circular(100.0),
        child: Stack(
          children: [
            
            Hero(
             tag:"image-profile-photo",
             child:ClipRRect(
               borderRadius: BorderRadius.circular(100.0),
               child: personEditProvider.getPhoto,
             )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 35.0,
                color: Colors.black38,
               child:  IconEditImage(),
                       ),
            ),
          ]),
      ),
    );
  }
}


class IconEditImage extends StatelessWidget {
  const IconEditImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final personEditProvider = Provider.of<PersonToEditProvider>(context,listen: true);
     final personServices = Provider.of<PersonInfoServices>(context,listen: true);

    return personEditProvider.isSaving ? Container(width: 30,height: 30,child: CircularProgressIndicator(color: Colors.indigo,),) :
    personEditProvider.isEditing ?
     IconButton(
                      onPressed: () async {
                        final String? image = await personEditProvider.uploadImage();
                        if(image!=null){
                          final data = await personServices.savePersonInfoServices(personEditProvider.personToEdit, personEditProvider.personToEdit.id!);
                          if(data!=null){
                            personServices.updatePersonActive = personEditProvider.personToEdit;
                          }
                        }
                      }, 
                      icon: Icon( Icons.save, size: 20, color: Colors.white ),
                    )
                    : 
                    IconButton(
                      onPressed: () async {
                        
                        final picker = new ImagePicker();
                        final PickedFile? pickedFile = await picker.getImage(
                          // source: ImageSource.gallery,
                          source: ImageSource.gallery,
                          imageQuality: 100
                        );
            
                        if( pickedFile == null ) {
                          return;
                        }
                        personEditProvider.updateSelectedImagePerson(pickedFile.path);
                        //personService.updateSelectedImagePerson(pickedFile.path);
                      }, 
                      icon: Icon( Icons.camera_alt_outlined, size: 20, color: Colors.white ),
                    );
  }
}