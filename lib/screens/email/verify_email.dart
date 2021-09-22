import 'dart:async';

import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:flutter/cupertino.dart';

class VerifyEmail extends StatefulWidget {
 static const id ="verify";
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  bool onEditing = true;
  bool _isResendAgain = false;
  bool isVerified = false;
  bool isLoading = false;

  String code = '';


  late Timer timer;
  int _start = 60;

  void startTimer() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        setState(() {
          if (_start == 0) {
            _start = 60;
            _isResendAgain = false;
            timer.cancel();
          } else {
            _start--;
          }
        });
      },
    );
  }

  verify() {
    setState(() {
     isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _authProvider = Provider.of<AuthProvider>(context,listen:false);
    return Scaffold(
      backgroundColor: Config.white,
      appBar: AppBar(
        backgroundColor: Config.white,
        elevation: 0,
        title: Text("Verify Email",style: GoogleFonts.ubuntu(color:Config.black,fontWeight: FontWeight.w500,fontSize: 24),),
        leading: IconButton(
            color:Config.black,
          icon:Icon(CupertinoIcons.back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body:SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: screenSize(context).height,
          width: screenSize(context).width,
          child: Column(
            children:[

              Config.emailSent.paddingOnly(top:20),

              RichText(
                text:TextSpan(
                  text:"Please enter the ",
                  style: GoogleFonts.ubuntu(color:Colors.grey,fontWeight: FontWeight.w400,fontSize: 18,),
                  children: [
                    TextSpan(
                    text:"4 digit code",
                      style: GoogleFonts.ubuntu(color:Config.color_1,fontWeight: FontWeight.w400,fontSize: 18,),
                    ),
                    TextSpan(
                      text:" sent to ${_authProvider.client?.email ?? "issamelbouhati@gmail.com"}"
                    )

                  ]
                )
                ,textAlign: TextAlign.center,
                ).paddingOnly(top:20),
              VerificationCode(
                textStyle: TextStyle(fontSize: 20.0, color: Colors.black),
                underlineColor: Colors.blueAccent,
                keyboardType: TextInputType.number,
                length: 4,
                onCompleted: (String value) {
                  setState(() {
                    code = value;
                  });
                },
                onEditing: (bool value) {
                  setState(() {
                    onEditing = value;
                  });
                },
              ).paddingOnly(top:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't receive the code?",
                    style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey.shade500),),
                  TextButton(
                      onPressed: () {
                        if (_isResendAgain) return;
                        startTimer();
                      },
                      child: Text(_isResendAgain ? 'Try again in ' + _start.toString() : "Resend",
                        style: TextStyle(fontSize: 14, height: 1.5, color: Colors.blueAccent),)
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {

                },
                child: Text(
                  "Verify",
                  style: GoogleFonts.ubuntu(fontSize: 22),
                ),
                style: ElevatedButton.styleFrom(
                    shadowColor: Config.color_1,
                    primary: Config.color_1,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5),
                    ),
                    fixedSize: Size(270, 50)),
              ).paddingOnly(top: 50),

            ]
          ),
        ),
      )
    );
  }
}

