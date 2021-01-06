import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/screens/product_page.dart';
import 'package:nike_app/services/firebase.dart';
import 'package:nike_app/widgets/custom_action.dart';

import '../constants.dart';

class CartPage extends StatefulWidget {
  final String size;

   CartPage({ this.size}) ;
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FireBaseService fireBaseService=FireBaseService();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: fireBaseService.usersRef.doc(fireBaseService.getUserId())
            .collection("Cart").get(),
            builder: (context,snapshot){
              if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }
              // list view
              if(snapshot.connectionState== ConnectionState.done){
                return  ListView(
                  padding: EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data.docs.map((document) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=> ProductPage(productId: document.id,)));
                      },
                      child: FutureBuilder(
                        future: fireBaseService.productRef.doc(document.id).get(),
                        builder: (context,productSnap){
                            if(productSnap.hasError){
                              return Container(
                                child: Center(child: Text("${productSnap.error}"),),
                              );
                            }
                            if(productSnap.connectionState==ConnectionState.done){
                              Map productMap = productSnap.data.data();

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24.0,
                                  horizontal: 24.0
                                ),
                                child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12.0)
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 24.0
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image(image: NetworkImage(
                                              "${productMap["images"][0]}"
                                            ),height: 100.0,),

                                            Container(
                                              padding: EdgeInsets.only(
                                            left: 16.0
                                            ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Text("${productMap["name"]}",
                                                    style: Constants.boldHeading,),
                                                  ),
                                                  Text("\$${productMap["price"]}",style: TextStyle(
                                                    color: Theme.of(context).accentColor
                                                  ),),
                                                  Text("Size - ${document.data()["size"]}",style: Constants.regularDarkText,)
                                                ],
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                              ),
                                            ),

                                          ],

                                        )



                                ),
                              );
                            }
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ) ,
                            );

                        },
                      )
                    );
                  }).toList(),
                );
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrow: true,
            title : "Cart",

          )

        ],
      ),

    );
  }
}
