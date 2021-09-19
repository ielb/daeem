import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/widgets/inputField.dart';
import 'package:flutter/cupertino.dart';
import 'package:daeem/services/services.dart';

class Login extends StatefulWidget {
  static const id = "/login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  AuthProvider _authProvider = AuthProvider();
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
  void didChangeDependencies() {
    _authProvider = Provider.of<AuthProvider>(context);
        super.didChangeDependencies();
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
  ///validation
  _validate(){
    if(_formkey.currentState!.validate()) {
      setState((){
        _isValidate=true;
      });
      if (Config.isEmail(_emailController!.text.trim())&&Config.isPassword(_passwordController!.text)) {
        _login(_emailController!.text,_passwordController!.text);
       //
      } else {

      }
    }else{
      setState((){
        _isValidate=false;
      });
    }
  }
  ///Login
 void _login(String email,String password)async{
    var result = await _authProvider.loginWithEmail(email,password);
    if(result) Navigator.pushReplacementNamed(context, Home.id);
    else Toast.show(AppLocalizations.of(context)!.wentWrong,context);
  }
  ///google button
 void signInWithGoogle()async{
   bool result = await _authProvider.socialLogin("google");
   if(result){
     Navigator.pushReplacementNamed(context, Home.id);
   }else
     Toast.show(AppLocalizations.of(context)!.wentWrong, context,duration: 2);
  }
  ///facebook button
  void signInWithFacebook()async{
    bool result = await _authProvider.socialLogin("facebook");
    if(result){
      Navigator.pushReplacementNamed(context, Home.id);
    }else
      Toast.show(AppLocalizations.of(context)!.wentWrong, context,duration: 2);

  }

  @override
  Widget build(BuildContext context) {
    var locale = Provider.of<LocaleProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async => false,
      child: _authProvider.isLoading ?  Loading() : Scaffold(
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
                Align(
            alignment:locale.locale == Locale('ar')  ? Alignment.topRight : Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context)!.signIn,
                    style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600),
                  )
                      .paddingOnly(left:locale.locale == Locale('ar')  ? 0 : 35,right: locale.locale == Locale('ar')  ? 35 : 0, bottom: 10)
                      ,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 30),
                  height:_isValidate? locale.locale == Locale('ar')  ?  460 : 440 : 477,
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
                      ).paddingOnly(top: 10),
                      RichText(
                        locale: locale.locale,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.welcome + "\n",
                                style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 28,
                                    color: Config.color_1),
                              ),
                              TextSpan(
                                  text: AppLocalizations.of(context)!.love,
                                  style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Config.color_1))
                            ],
                          )).paddingOnly(top: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            ///Google
                            IconButton(icon:Config.google,onPressed:signInWithGoogle,iconSize:40),
                            SizedBox(width: 20,),
                            ///Facebook
                            IconButton(icon :Config.facebook,onPressed:signInWithFacebook,iconSize: 40,),
                          ]
                      ),
                      Form(
                        key: _formkey,
                          child: Column(
                        children: [
                          Input(_emailController!,AppLocalizations.of(context)!.email,
                              Icons.email_outlined),
                          Input(
                            _passwordController!,
                            AppLocalizations.of(context)!.password,
                            Icons.lock_outline_rounded,
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
                          AppLocalizations.of(context)!.signIn,
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
                          Prefs.instance.setAuth(false);
                         Navigator.pushReplacementNamed(context,Home.id);
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
                  Text(AppLocalizations.of(context)!.don_have_acc,
                      style: GoogleFonts.ubuntu(
                          color: Colors.black45, fontSize: 18)),
                  GestureDetector(
                      onTap: () {
                        _formkey.currentState!.reset();
                         Navigator.pushNamed(context, SignUp.id);
                      },
                      child: Text(AppLocalizations.of(context)!.signup,
                          style: GoogleFonts.ubuntu(
                              color: Config.color_1,
                              fontSize: 18,
                              decoration: TextDecoration.underline)))
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
