import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;
  BottomTabs({this.selectedTab,this.tabPressed});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab=0;


  @override
  Widget build(BuildContext context) {
    _selectedTab=  widget.selectedTab ?? 0;

    return   Container(
      decoration: BoxDecoration(
        borderRadius:  BorderRadius.only(
          topLeft:  Radius.circular(12.0),
          topRight: Radius.circular(12.0)
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1.0,
            blurRadius: 30.0
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabButton(imagePath: "assets/images/home.png",
            selected: _selectedTab==0 ? true : false,
            onPressed: (){
              widget.tabPressed(0);
              },),
          BottomTabButton(imagePath: "assets/images/loupe.png",
             selected:  _selectedTab==1 ? true : false,
              onPressed: (){
                widget.tabPressed(1);
          }),
          BottomTabButton(imagePath:  "assets/images/ribbon.png",
              selected:  _selectedTab==2 ? true : false,
              onPressed: (){
                widget.tabPressed(2);

              }),
          BottomTabButton(imagePath: "assets/images/logout.png",
              selected:  _selectedTab==3? true : false,
              onPressed: (){
                FirebaseAuth.instance.signOut();

              }),

        ],
      ),
    );
  }
}

class BottomTabButton extends StatelessWidget {
  final String imagePath;
  final bool selected;
  final Function onPressed;
   BottomTabButton({this.imagePath,this.selected,this.onPressed}) ;

  @override
  Widget build(BuildContext context) {
    bool _selected= selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top : BorderSide(
              color: _selected ? Theme.of(context).accentColor: Colors.transparent,
              width: 2.0
            ),
          )
        ),
        padding: EdgeInsets.symmetric(
            vertical: 24.0,horizontal: 16.0
        ),
        child: Image(
          height: 22.0,
          width: 22.0,
          image: AssetImage(
            imagePath  ??  "assets/images/home.png"
          ),
          color: _selected ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
    );
  }
}
