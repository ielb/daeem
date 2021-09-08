import 'package:daeem/configs/config.dart';
import 'package:daeem/widgets/inputField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daeem/services/services.dart';

class Login extends StatefulWidget {
  static const id = "/login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: screenSize(context).width,
            height: screenSize(context).height,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(Config.auth_background),
              fit: BoxFit.fitHeight,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.signIn,
                  style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600),
                ).paddingOnly(left: 35, bottom: 10).align(alignment: Alignment.topLeft),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 50),
                  height: screenSize(context).height * .65,
                  width: screenSize(context).width * .85,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Image.asset(
                        Config.logo,
                        width: 200,
                      ).paddingOnly(top: 10),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Welcome back" + "\n",
                                style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 28,
                                    color: Config.color_1),
                              ),
                              TextSpan(
                                  text: "We love to see again",
                                  style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Config.color_1))
                            ],
                          )).paddingOnly(top: 20),
                      Form(
                          child: Column(
                        children: [
                          Input("Email Address", Icons.email_outlined),
                          Input("Password", Icons.lock_outline_rounded),
                        ],
                      )).paddingOnly(top: 30),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Login", style: GoogleFonts.ubuntu(fontSize: 22),),
                        style: ElevatedButton.styleFrom(
                            shadowColor: Config.color_1,
                            primary: Config.color_1,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5),
                            ),
                            fixedSize: Size(270, 50)),
                      ).paddingOnly(top: 15, bottom: 10),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text("Skip"),
                        style: OutlinedButton.styleFrom(
                          primary: Config.color_1,
                            side: BorderSide(color: Config.color_1, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(6),
                            ),
                            textStyle: GoogleFonts.ubuntu(fontSize: 22),
                            fixedSize: Size(270, 50)),
                      ),
                    ],
                  ),
                ),
                Row( mainAxisAlignment: MainAxisAlignment.center,
                    children:[Text("Don't have an account ? ",style:GoogleFonts.ubuntu(color:Colors.black45,fontSize: 18)),
                      GestureDetector(
                        onTap: (){},
                          child:Text("Sign Up",style:GoogleFonts.ubuntu(color:Config.color_1,fontSize: 18,decoration: TextDecoration.underline))
                      )
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
