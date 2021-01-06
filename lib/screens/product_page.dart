import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/constants.dart';
import 'package:nike_app/services/firebase.dart';
import 'package:nike_app/widgets/custom_action.dart';
import 'package:nike_app/widgets/image%20swipe.dart';
import 'package:nike_app/widgets/product_size.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FireBaseService _fireBaseService=FireBaseService();
  String _selectedProductSize= "0";
  Future _addToCart() {
    return _fireBaseService.usersRef
        .doc(_fireBaseService.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }
  Future _addToSaved() {
    return _fireBaseService.usersRef
        .doc(_fireBaseService.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }
    SnackBar _snackBar=SnackBar(content: Text("Product added to the card"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder(
          future: _fireBaseService.productRef.doc(widget.productId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                  body: Center(child: Text("Error ${snapshot.error}")));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              // FireBase document data map
              Map<String, dynamic> data = snapshot.data.data();
              // List of Images
              List imageList = data["images"];
              List productSizes = data["size"];
              _selectedProductSize=productSizes[0];
              return ListView(
                padding: EdgeInsets.all(0),
                children: [
                  ImageSwipe(
                    imageList: imageList,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 24.0, left: 24.0, right: 24.0, bottom: 4.0),
                    child: Text(
                      "${data["name"]}",
                      style: Constants.boldHeading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 24.0),
                    child: Text("\$${data["price"]}",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24.0),
                    child: Text("${data["desc"]}",
                        style: TextStyle(
                          fontSize: 18.0,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 24.0),
                    child: Text(
                      "Select Size",
                      style: Constants.regularDarkText,
                    ),
                  ),
                  ProductSize(
                    productSizes: productSizes,
                    onSelected: (size){
                      _selectedProductSize=size;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () async{
                              await _addToSaved();
                              Scaffold.of(context).showSnackBar(_snackBar);
                           },
                          child: Container(
                            height: 55.0,
                            width: 65.0,
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage(
                                "assets/images/ribbon.png",
                              ),
                              height: 22.0,
                              // width: 20.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),

                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                                await _addToCart();
                                Scaffold.of(context).showSnackBar(_snackBar);

                            },
                            child: Container(
                              height: 55.0,
                              margin: EdgeInsets.only(left: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Add to card",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: Scaffold(
                body: Center(child: Center(child: CircularProgressIndicator(strokeWidth: 2.0,),)
              ),
            ));
          },
        ),
        CustomActionBar(
          hasBackArrow: true,
          hasTitle: false,
          hasBackgroung: false,
          size: _selectedProductSize,
        )
      ],
    ));

  }
}
