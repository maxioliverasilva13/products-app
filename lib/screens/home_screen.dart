import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';

import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final personProfile = Provider.of<PersonInfoServices>(context);
    
    if( productsService.isLoading ) return LoadingScreen();


    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        leading: IconButton(
          icon: Icon( Icons.login_outlined ),
          onPressed: () {

            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');

          },
          
        ),
        actions: [

          Container(
            margin: EdgeInsets.only(right: 10.0),
            width: 45.0,
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, "profile");
              },
              child: Hero(
                tag:"image-profile-photo",
                child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                          NetworkImage(personProfile.personActive.photo ?? "https://icon-library.com/images/no-user-image-icon/no-user-image-icon-0.jpg"),
                      backgroundColor: Colors.transparent,
                    ),
              ),
            ),
          )
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         // number of items per row
        crossAxisCount: 2,
        mainAxisExtent:330,
         // vertical spacing between the items
         mainAxisSpacing: 2,
         // horizontal spacing between the items
         crossAxisSpacing: 0.5,
        ),
        itemCount: productsService.products.length,
        itemBuilder: ( BuildContext context, int index ) => GestureDetector(
          onTap: () {
            productsService.selectedProduct = productsService.products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child:ProductCard(
            product: productsService.products[index],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        onPressed: () {

          productsService.selectedProduct = new Product(
            likes: [],
            available: false, 
            name: '', 
            price: 0,
            personId: "",
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
   );
  }
}