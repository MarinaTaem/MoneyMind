// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_mind/models/connect_database.dart';
import 'package:money_mind/Screen/sign_in_screen.dart';
import 'package:money_mind/styles/color.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passWordController = TextEditingController();
  final _confirmPWDController = TextEditingController();

  bool isPwdVisible = false;
  bool isCPwdVisible = false;

  final dbHelper = DatabaseHelper();

  void _signUp() async {
    final username = _usernameController.text;
    final password = _passWordController.text;

    if (_formkey.currentState!.validate()) {
      final result = await dbHelper.registerUser(username, password);

      if (result == -1) {
        _showMessage('Email is already registered.');
      } else {
        _showMessage('Sign-Up Successful!');
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
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.only(right: 40, left: 40, top: 150),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment
              //     .center, // Center the column's children vertically
              // Center the column's children horizontally
              children: [
                Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 70,
                ), // Add some space between the Text and TextFormFields

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
                        isPwdVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPwdVisible = !isPwdVisible; // Toggle the visibility
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
                  obscureText: !isPwdVisible,
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
                  height: 20,
                ),
                TextFormField(
                  controller: _confirmPWDController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isCPwdVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isCPwdVisible =
                              !isCPwdVisible; // Toggle the visibility
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
                  obscureText: !isCPwdVisible,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passWordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: 40,
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
                      _signUp();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColors.secondaryColor,
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 70),
                Text(
                  'Or you already have an account, ',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
