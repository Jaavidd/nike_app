import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/constants.dart';
import 'package:nike_app/screens/homepage.dart';
import 'package:nike_app/screens/login_page.dart';

class LandingPage extends StatelessWidget {

  final Future<FirebaseApp>  _initialization  =  Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error ${snapshot.error}"),
              ),
            );
          }
          // Connection made to firebase
          if (snapshot.connectionState == ConnectionState.done) {
            //StreamBuilder can check the login state live
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context,streamSnapshot){
                if (streamSnapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error ${streamSnapshot.error}"),
                    ),
                  );
                }
                // connection state active - Do the user login check
                // inside if statement
                if(streamSnapshot.connectionState==ConnectionState.active){
                  User _user=streamSnapshot.data;
                  return (_user == null)
                      ? LoginPage() : HomePage();

                }
                // Checking the auth state - Loading
                return
                    Scaffold(
                      body: Center(
                        child: Container(
                            child: Center(
                                child: Text("  Nike "))
                        ),
                      ),
                    );



              },
            );
          }
          return Scaffold(
            body: Text(
              "Initialization App...",
              style: Constants.regularHeading,
            ),
          );
        });
  }
}
