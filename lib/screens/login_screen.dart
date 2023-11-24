import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_prishu/constants.dart';
import 'package:flash_chat_prishu/custom_widgets/circled_button.dart';
import 'package:flash_chat_prishu/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '';
  final _auth = FirebaseAuth.instance;
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kInputDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kInputDecoration.copyWith(
                  hintText: 'Enter your password.',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              CustomCircledButton(
                buttonText: 'Log In',
                selectedColor: Colors.lightBlueAccent,
                onPress: () async {
                  setState(() {
                    _showSpinner = true;
                  });
                  //Implement login functionality.
                  print('Login Email: $email');
                  print('Login Password: $password');
                  try {
                    final isValidLogin = await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (isValidLogin != null) {
                      // print(
                      //     'Login screen email id: ${isValidLogin['UserCredential']['user']['User']['email']}');
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      _showSpinner = false;
                    });
                  } catch (e) {
                    setState(() {
                      _showSpinner = false;
                    });
                    print('Exception in Login Screen: $e');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
