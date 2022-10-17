import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/models/comments.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/models/personInfo.dart';
import 'package:productos_app/providers/comments_provider.dart';
import 'package:productos_app/widgets/comment_item.dart';

import 'package:provider/provider.dart';
import 'package:productos_app/providers/product_form_provider.dart';

import 'package:productos_app/services/services.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:productos_app/widgets/text_with_icon.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    final personServices = Provider.of<PersonInfoServices>(context);

    return productService.selectedProduct.id != null
        ? FutureBuilder(
            future: personServices
                .findPersonInfo(productService.selectedProduct.personId),
            builder: (BuildContext context, AsyncSnapshot<Person?> snapshot) {
              if (snapshot.hasData) {
                return ChangeNotifierProvider(
                  create: (_) =>
                      ProductFormProvider(productService.selectedProduct),
                  child: _ProductScreenBody(
                    productService: productService,
                    personOwner: snapshot.data!,
                  ),
                );
              } else {
                return Center(
                  child: Scaffold(
                    body: Center(
                        child: CircularProgressIndicator(
                      color: Colors.indigo,
                    )),
                  ),
                );
              }
            },
          )
        : ChangeNotifierProvider(
            create: (_) => ProductFormProvider(productService.selectedProduct),
            child: _ProductScreenBody(
              productService: productService,
              personOwner: null,
            ),
          );

    /*
 
    */
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
    this.personOwner,
  }) : super(key: key);

  final ProductsService productService;
  final Person? personOwner;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final personServices = Provider.of<PersonInfoServices>(context);
    print(productService.selectedProduct.comments);
    return Scaffold(
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  url: productService.selectedProduct.picture,
                  width: double.infinity,
                  height: 450,
                  radius: 45,
                ),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios_new,
                          size: 40, color: Colors.white),
                    )),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      onPressed: () async {
                        final picker = new ImagePicker();
                        final PickedFile? pickedFile = await picker.getImage(
                            // source: ImageSource.gallery,
                            source: ImageSource.gallery,
                            imageQuality: 100);
                        if (pickedFile == null) {
                          print('No seleccionó nada');
                          return;
                        }
                        productService
                            .updateSelectedProductImage(pickedFile.path);
                      },
                      icon: Icon(Icons.camera_alt_outlined,
                          size: 40, color: Colors.white),
                    ))
              ],
            ),
            if (personOwner != null)
              ProductOwnerInfo(
                owner: personOwner!,
              ),
            _ProductForm(),
            SizedBox(height: 100),
            Comments(
              activeProduct: this.productService.selectedProduct,
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: productService.isSaving
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.save_outlined),
        onPressed: productService.isSaving
            ? null
            : () async {
                if (!productForm.isValidForm()) return;

                final String? imageUrl = await productService.uploadImage();

                if (imageUrl != null) productForm.product.picture = imageUrl;

                await productService.saveOrCreateProduct(
                    productForm.product, personServices.personActive.id!);
              },
      ),
    );
  }
}

class ProductOwnerInfo extends StatelessWidget {
  final Person owner;
  const ProductOwnerInfo({Key? key, required this.owner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 5),
                  blurRadius: 5)
            ]),
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Vendedor",
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  //owner image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: FadeInImage(
                      width: 70,
                      height: 70,
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      image: NetworkImage(owner.photo ??
                          "https://icon-library.com/images/no-user-image-icon/no-user-image-icon-0.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  Text(
                    owner.name,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            TextWithIcon(
                margin: 8.0,
                icono: Icons.location_city,
                name: "Pais",
                value: owner.city),
            TextWithIcon(
                margin: 8.0,
                icono: Icons.email,
                name: "Email",
                value: owner.email),
          ],
        ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del producto', labelText: 'Nombre:'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '\$150', labelText: 'Precio:'),
              ),
              SizedBox(height: 30),
              SwitchListTile.adaptive(
                  value: product.available,
                  title: Text('Disponible'),
                  activeColor: Colors.indigo,
                  onChanged: productForm.updateAvailability),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 5),
                blurRadius: 5)
          ]);
}

class Comments extends StatelessWidget {
  final Product activeProduct;
  const Comments({Key? key, required this.activeProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CommentsProvider(activeProduct.comments ?? []),
        child: CommentsList());
  }
}

class CommentsList extends StatelessWidget {
  const CommentsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsProvider>(context);
    return Container(
      child: Column(
        children: [
          Text(
            "Comentarios",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: Offset(0, 5),
                        blurRadius: 5),
                  ]),
              child: Column(
                children: [
                  SingleChildScrollView(
                      child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: CommentsItemLists(
                              comments: commentsProvider.comments))),
                  CreateComment(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentsItemLists extends StatelessWidget {
  final List<Comment>? comments;
  const CommentsItemLists({Key? key, required this.comments}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments?.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return CommentItem(comment: comments![index]);
      },
    );
  }
}
