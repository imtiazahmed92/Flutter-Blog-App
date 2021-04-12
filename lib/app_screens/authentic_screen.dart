import 'package:blog_app/app_screens/home_screen.dart';
import 'package:blog_app/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();

  String _buttonText  = 'Login';
  String _switchText = 'Don\'t have an account? Register';

  bool _loading = false;

  void _validateFields(){
    if(_emailEditingController.text.isEmpty && _passwordEditingController.text.isEmpty){
      //show messegw: Please enter your email and password
      Fluttertoast.showToast(
        msg: 'Please enter your email and password',
        backgroundColor: Colors.redAccent
      );
    }
    else  if(_emailEditingController.text.isEmpty)  {
      //please enter your email
      Fluttertoast.showToast(
        msg: 'Please enter your email',
        backgroundColor: Colors.redAccent,
      );
    }
    else if(_passwordEditingController.text.isEmpty){
      //please enter your password
      Fluttertoast.showToast(
        msg: 'Please enter your password',
        backgroundColor: Colors.redAccent
      );
    }
    else  {

      setState(() {
        _loading = true;
      });

      if(_buttonText  == 'Login')
        _login();
        else
          _register();

    }
  }

  void _moveToHomeScreen()  {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context)  =>HomeScreen()),
    );
  }

  void _login() {
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailEditingController.text,
      password: _passwordEditingController.text,
    ).then((UserCredential userCredential){
      //Move to the home screen
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: 'Login Successfull',
          backgroundColor: Colors.redAccent
      );
      _moveToHomeScreen();
    }).catchError((error){
      //show error messege
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: error.toString(),
          backgroundColor: Colors.redAccent
      );
    });
  }

  void _register()  {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailEditingController.text,
      password: _passwordEditingController.text,
    ).then((UserCredential userCredential){
      //Move to the home screen
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: 'Registered Successfully',
          backgroundColor: Colors.redAccent
      );
      _moveToHomeScreen();
    }).catchError((error){
      //shwo error messege
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: error.toString(),
          backgroundColor: Colors.redAccent
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Blog App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children:<Widget> [
                SizedBox(height: 30.0),
                Image.asset(
                  "assets/images/logo.png",
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 30.0),
                TextField(
                  controller: _emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: _passwordEditingController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
                SizedBox(height: 40.0),
                _loading ? circularProgress() : GestureDetector(
                  onTap: _validateFields,
                  child: Container(
                    color: Colors.pink,
                    width: double.infinity,
                    height: 50.0,
                    child: Center(
                      child: Text(
                          _buttonText,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                FlatButton(
                  textColor: Colors.pink,
                  onPressed: (){
                    setState(() {
                      if(_buttonText  == 'Login'){
                          _switchText = 'Login';
                          _buttonText = 'Registre';
                      } else {
                        _buttonText = 'Login';
                        _switchText = 'Don\'t have an account? Register';
                      }
                    });
                  },
                  child: Text(
                    _switchText,
                    style: TextStyle(
                        fontSize: 18.0
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
