

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_messenger/global/global.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

GoogleSignIn googleSignIn = GoogleSignIn();
  //Google Sign In:
  Future googleSignInSection()async{
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // ignore: unnecessary_null_comparison
    if(googleSignIn != null){
      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken

      );

      UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
    await firebaseFirestore.collection("users").doc(userCredential.user!.uid).set({

      "email" : userCredential.user!.email,
      "name" : userCredential.user!.displayName,
      "image" : userCredential.user!.photoURL,
      "date" : DateTime.now()
      
    });

    }
    return;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              // ignore: avoid_unnecessary_containers
              child: Container(
            child: Lottie.asset("assets/welcome.json"),
          )),
          Text(
            "SMS Messenger",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: ElevatedButton(
              onPressed: () async{
                await googleSignInSection();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png",
                    height: 4.h,
                  ),
                  SizedBox(
                    width: 3.h,
                  ),
                  Text(
                    "Sign In With Google",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  )
                ],
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 2.h))),
            ),
          )
        ],
      )),
    );
  }
}
