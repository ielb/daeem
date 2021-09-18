import 'package:daeem/widgets/inputField.dart';
import 'package:flutter/cupertino.dart';
import 'package:daeem/services/services.dart';

class SignUp extends StatefulWidget {
  static const id = "signup";

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  bool _isVisible = true;
  bool _isValidate = true;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();

    super.dispose();
  }

  _showPassword() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  _validate(){
    if(_formkey.currentState!.validate()) {
      setState((){
        _isValidate=true;
      });
      if (Config.isEmail(_emailController!.text) &&
          Config.isPassword(_passwordController!.text)) {
        //Login logic
        Navigator.pushReplacementNamed(context, 'home');
      } else {

      }
    }else{
      setState((){
        _isValidate=false;
      });
    }
  }

  _googleLogin(){

  }
  _facebookLogin(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text(AppLocalizations.of(context)!.signup,
                style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600),
              )
                  .paddingOnly(left: 35, bottom: 10)
                  .align(alignment: Alignment.topLeft),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 30),
                height:_isValidate ?   420 : 500 ,
                width: screenSize(context).width * .85,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Image.asset(
                      Config.logo,
                      width: 200,
                      filterQuality: FilterQuality.high,
                    ).paddingOnly(top: 10,bottom:10),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.join + "\n",
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28,
                                  color: Config.color_1),
                            ),
                            TextSpan(
                                text: AppLocalizations.of(context)!.love_join,
                                style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: Config.color_1))
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        IconButton(icon:Config.google,onPressed:_googleLogin,iconSize:40),
                        SizedBox(width: 20,),
                        IconButton(icon :Config.facebook,onPressed:_facebookLogin,iconSize: 40,),
                      ]
                    ),
                    Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Input(_emailController!, AppLocalizations.of(context)!.email,
                                Icons.email_outlined),
                            Input(
                              _passwordController!,
                              AppLocalizations.of(context)!.password,
                               CupertinoIcons.lock,

                              showPassword: _showPassword,
                              isPassword: true,
                              obscureText: _isVisible,
                            ),
                          ],
                        )),
                    ElevatedButton(
                      onPressed: () {
                        _validate();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.signup,
                        style: GoogleFonts.ubuntu(fontSize: 22),
                      ),
                      style: ElevatedButton.styleFrom(
                          shadowColor: Config.color_1,
                          primary: Config.color_1,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5),
                          ),
                          fixedSize: Size(270, 50)),
                    ).paddingOnly(top: 5, bottom: 10),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context,'market');
                      },
                      child: Text(AppLocalizations.of(context)!.skip),
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(AppLocalizations.of(context)!.have_acc,
                    style: GoogleFonts.ubuntu(
                        color: Colors.black45, fontSize: 18)),
                GestureDetector(
                    onTap: () {
                      _formkey.currentState!.reset();
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.signIn,
                        style: GoogleFonts.ubuntu(
                            color: Config.color_1,
                            fontSize: 18,
                            decoration: TextDecoration.underline)))
              ])
            ],
          ),
        ),
      ),
    );
  }
}