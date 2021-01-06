
import 'package:flutter/material.dart';
import 'package:nike_app/screens/product_page.dart';

import '../constants.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final Function onPressed;
  final String image;
  final String name;
  final String price;

  ProductCard({Key key, this.onPressed, this.image, this.name, this.price,this.productId}) ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=> ProductPage(productId:productId,)));
      },
      child: Container(
        height: 350.0,
        margin: EdgeInsets.symmetric(
            vertical: 12.0, horizontal: 24.0
        ),
        child: Stack(
          children: [
            Container(
              height: 350.0,
              width: 400.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(image,
                  fit: BoxFit.cover,),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: Constants.regularHeading,),
                    Text("\$${price}" ,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
