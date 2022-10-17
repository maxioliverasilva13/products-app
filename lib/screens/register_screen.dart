import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/models/personInfo.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/services/services.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox( height: 250 ),

              CardContainer(
                child: Column(
                  children: [

                    SizedBox( height: 10 ),
                    Text('Crear cuenta', style: Theme.of(context).textTheme.headline4 ),
                    SizedBox( height: 30 ),
                    
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _LoginForm()
                    )
                    

                  ],
                )
              ),

              SizedBox( height: 50 ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'login'), 
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all( Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all( StadiumBorder() )
                ),
                child: Text('¿Ya tienes una cuenta?', style: TextStyle( fontSize: 18, color: Colors.black87 ),)
              ),
              SizedBox( height: 50 ),
            ],
          ),
        )
      )
   );
  }
}


class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [

              ImageSelector(),

              TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'John Washingron',
                labelText: 'Nombre',
                prefixIcon: Icons.text_fields
              ),
              onChanged: ( value ) => loginForm.name = value,
              validator: ( value ) {
                  return value!=null && value.length > 2
                    ? null
                    : 'El valor ingresado no es un nombre valido';
              },
            ),

            SizedBox( height: 30 ),


             TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Dinamarca',
                labelText: 'Pais',
                prefixIcon: Icons.location_on
              ),
              onChanged: ( value ) => loginForm.city = value,
              validator: ( value ) {
                  return value!=null && value.length > 2
                    ? null
                    : 'El valor ingresado no es un pais valido';
              },
            ),

            SizedBox( height: 30 ),

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Montevideo',
                labelText: 'Ciudad',
                prefixIcon: Icons.location_city
              ),
              onChanged: ( value ) => loginForm.country =value ,
              validator: ( value ) {
                  return value!=null && value.length > 2
                    ? null
                    : 'El valor ingresado no es una ciudad valida';
              },
            ),

            SizedBox( height: 30 ),

            
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded
              ),
              onChanged: ( value ) => loginForm.email = value,
              validator: ( value ) {

                  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp  = new RegExp(pattern);
                  
                  return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';

              },
            ),

            SizedBox( height: 30 ),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: ( value ) => loginForm.password = value,
              validator: ( value ) {

                  return ( value != null && value.length >= 6 ) 
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';                                    
                  
              },
            ),

            SizedBox( height: 30 ),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading 
                    ? 'Espere'
                    : 'Ingresar',
                  style: TextStyle( color: Colors.white ),
                )
              ),
              onPressed: loginForm.isLoading ? null : () async {
                
                FocusScope.of(context).unfocus();
                final authService = Provider.of<AuthService>(context, listen: false);
                final personInfoServices = Provider.of<PersonInfoServices>(context, listen: false);
                
                if( !loginForm.isValidForm() ) return;

                loginForm.isLoading = true;

                // TODO: validar si el login es correcto
                final dynamic response = await authService.createUser(loginForm.email, loginForm.password);
                if(response["localId"]!=null){
                final localId = response["localId"];
                final url = await personInfoServices.uploadImage();
                final Person person = new Person(name: loginForm.name, country: loginForm.country, id:localId ,city: loginForm.city,photo: url ?? "https://icon-library.com/images/no-user-image-icon/no-user-image-icon-0.jpg",email:loginForm.email);
                final String? userCreated =  await personInfoServices.savePersonInfoServices(person,localId);
                if(userCreated!=null){
                  Navigator.pushReplacementNamed(context, 'home');
                }
                }else{
                  print( response["error"] );
                  loginForm.isLoading = false;
                }
              }
            )

          ],
        ),
      ),
    );
  }
}


class ImageSelector extends StatelessWidget {
  const ImageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final personService = Provider.of<PersonInfoServices>(context);
    return Container(
      width: 120,
      height: 120,
      child:  Stack(
        children: [
           ProductImage( url: personService.getUrl(),width: 100,height: 100,radius:200),
           Align(
             alignment: Alignment.bottomCenter,
             child:  IconButton(
                    onPressed: () async {
                      
                      final picker = new ImagePicker();
                      final PickedFile? pickedFile = await picker.getImage(
                        // source: ImageSource.gallery,
                        source: ImageSource.gallery,
                        imageQuality: 100
                      );

                      if( pickedFile == null ) {
                        print('No seleccionó nada');
                        return;
                      }

                      personService.updateSelectedImagePerson(pickedFile.path);
                    }, 
                    icon: Icon( Icons.camera_alt_outlined, size: 20, color: Colors.white ),
                  ),
           ),
             
           
        ]),
    );
  }
}

