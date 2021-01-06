import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/constants.dart';
import 'package:nike_app/screens/product_page.dart';
import 'package:nike_app/widgets/custom_action.dart';
import 'package:nike_app/widgets/product%20cart.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productRef=FirebaseFirestore.instance
      .collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productRef.get(),
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
                    return ProductCard(
                      name: document.data()["name"],
                      price: document.data()["price"].toString(),
                      image: document.data()["images"][0],
                      productId: document.id,

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
            title: "Home",
            hasBackArrow: false,
          ),

        ],
      ),
    );
  }
}
