// import 'dart:ffi';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_mind/Screen/main_screen.dart';
import 'package:money_mind/models/connect_database.dart';
import 'package:money_mind/pages/home_screen.dart';
import 'package:money_mind/Screen/sign_up_screen.dart';
import 'package:money_mind/styles/color.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passWordController = TextEditingController();

  final dbHelper = DatabaseHelper();

  bool isVisible = false;

  void _signIn() async {
    final username = _usernameController.text;
    final password = _passWordController.text;

    if (_formkey.currentState!.validate()) {
      final userId = await dbHelper.loginUser(
          username, password); // This will return the user ID

      if (userId != null) {
        _showMessage('Welcome, $username!');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              userId: userId, // Pass the user ID directly
            ),
          ),
        );
      } else {
        _showMessage('Invalid username or password.');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(right: 40, left: 40, top: 150),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Text(
                'Sign in To Your Account',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 20,
              ), // Add some space between the Text and TextFormFields

              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey, // Change this to your desired color
                      width: 2.0, // Change this to your desired width
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ), // Add some space between the TextFormFields
              TextFormField(
                controller: _passWordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible; // Toggle the visibility
                      });
                    },
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey, // Change this to your desired color
                      width: 2.0, // Change this to your desired width
                    ),
                  ),
                ),
                obscureText: !isVisible,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  } else if (value.length < 8) {
                    return 'Password must be more than 8 charactor';
                  } else if (!RegExp(
                          r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).+$')
                      .hasMatch(value)) {
                    return 'Include letters, numbers, and special characters.';
                  }
                  return null;
                },
              ),

              SizedBox(
                height: 60,
              ),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    // if (_formkey.currentState!.validate()) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Processing Data')),
                    //   );
                    // }
                    _signIn();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.secondaryColor,
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 70),
              Text(
                'Or don\'t have an account yet, ',
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
