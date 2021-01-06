import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/screens/register_page.dart';
import 'package:nike_app/widgets/custom_button.dart';
import 'package:nike_app/widgets/custom_input.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _alertDialogBuilder(String error) async {
    print(error.toString());
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("close dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },)
            ],
          );
        });
  }

  // create new user account
  Future<String> _signIn() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail.trim(), password: _loginPassword);
      return null;
    }on FirebaseAuthException catch(e ){
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return "The account already exists for that email.";
      }
      return e.message;
    }catch(e){
      return e.toString();
    }
  }


  void _submitForm() async{
    setState(() {
      _loginFromLoading=true;

    });

    String _createAccountFeedback= await _signIn();
    if(_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      setState(() {
        _loginFromLoading = false;
      });
    }

  }
  bool _loginFromLoading=false;

  //form input field values
  String _loginEmail = "";
  String _loginPassword="";
  // focus mode for input field
  FocusNode _passwordFocusNode;
  @override
  void initState() {
    _passwordFocusNode=FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 24.0,
                  ),
                  child: Text("Welcome User.\nLogin to your account",
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,),
                ),
                Column(
                  children: [
                    CustomInput(
                      hintText: "Email . . .",
                      onChanged: (value){
                        _loginEmail=value;
                      },
                      onSubmit: (value){
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    CustomInput(
                      hintText: "Password . . .",
                      onChanged: (value){
                        _loginPassword=value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmit: (value){
                        _submitForm();
                      },
                    ),
                    CustomButton(
                      text: "Login",
                      onPressed: (){
                        setState(() {
                          _submitForm();
                        });},
                      loading: _loginFromLoading,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: CustomButton(
                    text: "Create New Account",
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> RegisterPage())
                      );
                    },
                    outlineBtn: true,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
