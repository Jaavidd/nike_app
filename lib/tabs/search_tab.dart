import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/constants.dart';
import 'package:nike_app/services/firebase.dart';
import 'package:nike_app/widgets/custom_input.dart';
import 'package:nike_app/widgets/product%20cart.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FireBaseService fireBaseService =FireBaseService();

  String searchString= "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: fireBaseService.productRef.orderBy("name")
                .startAt([searchString]).endAt(["$searchString\uf8ff"]).get(),
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
          Padding
            (
            padding: const EdgeInsets.only(top:  45.0),
            child: CustomInput(
              hintText: "Search here. . .",
              onChanged: (value){
                if(value.isNotEmpty){
                  setState(() {
                    searchString=value.toLowerCase();
                  });
                }
              },
            ),
          ),


        ],
      )
    );
  }
}
