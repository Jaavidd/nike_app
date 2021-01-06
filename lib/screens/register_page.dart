import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/widgets/custom_button.dart';
import 'package:nike_app/widgets/custom_input.dart';

import '../constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  //Build and alert dialog to display error
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
  Future<String> _createAccount() async {
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _registerEmail.trim(), password: _registerPassword);
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
      _registerFromLoading=true;

    });

    String _createAccountFeedback= await _createAccount();
      if(_createAccountFeedback != null) {
        _alertDialogBuilder(_createAccountFeedback);

        setState(() {
          _registerFromLoading = false;
        });
      }
      else{
        Navigator.pop(context);
      }
  }
  bool _registerFromLoading=false;

  //form input field values
  String _registerEmail = "";
  String _registerPassword="";
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
              child: Text(
                "Create a New Account",
                textAlign: TextAlign.center,
                style: Constants.boldHeading,
              ),
            ),
            Column(
              children: [
                CustomInput(
                  hintText: "Email . . .",
                  onChanged: (value){
                    _registerEmail=value;
                  },
                  onSubmit: (value){
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  hintText: "Password . . .",
                  onChanged: (value){
                    _registerPassword=value;
                  },
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                  onSubmit: (value){
                    _submitForm();
                  },
                ),
                CustomButton(
                  text: "Create New Account",
                  onPressed: (){
                    setState(() {
                          _submitForm();
                    });},
                  loading: _registerFromLoading,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: CustomButton(
                text: "Back To Login",
                onPressed: () {
                  Navigator.pop(context);
                },
                outlineBtn: true,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
