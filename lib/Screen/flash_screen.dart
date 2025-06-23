// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_mind/Screen/sign_in_screen.dart';
import 'package:money_mind/Screen/sign_up_screen.dart';
import 'package:money_mind/styles/color.dart';

class FlashScreen extends StatelessWidget {
  const FlashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 270,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      'MoneyMind!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 300,
              height: 50, // Increased height for better touch target
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add your onPressed functionality here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                label: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                icon: SvgPicture.asset(
                  'assets/icons/sign_up.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  minimumSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Set your desired border radius here
                  ),
                  // Ensures consistent button size
                ),
              ),
            ),

            SizedBox(
              height: 40,
            ),
            // Sign in
            Container(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Or do you already have an account?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
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
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                height: 260,
                child: Image.asset(
                  'assets/images/flash_img.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
