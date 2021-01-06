import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;
  ImageSwipe({this.imageList});
  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedPage=0;
  @override
  Widget build(BuildContext context) {
    return   Container(
        width: double.infinity,
        height: 400.0,
        child: Stack(
          children: [
            PageView(
              onPageChanged: (num){
                setState(() {_selectedPage=num;});
              },
              children: [
                for(var i=0;i<widget.imageList.length;i++)
                  Container(
                    child: Image.network(
                      "${widget.imageList[i]}",
                      fit: BoxFit.cover,
                    ),
                  ),

              ],
            ),
            Positioned(
              bottom: 20.0,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  for(var i=0;i<widget.imageList.length;i++)
                    AnimatedContainer(
                      duration: Duration(milliseconds:200),
                      curve: Curves.easeInCubic,
                      margin: EdgeInsets.symmetric(
                        horizontal: 5.0
                      ),
                      width:  12.0,
                        height: 12.0,
                      decoration: BoxDecoration(
                        color: _selectedPage==i ? Theme.of(context).accentColor : Colors.white,
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                    )

                ],
              ),
            ),
          ],
        )
    );
  }
}
