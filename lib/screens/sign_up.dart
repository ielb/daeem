import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/widgets/inputField.dart';
import 'package:flutter/cupertino.dart';
import 'package:daeem/services/services.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignUp extends StatefulWidget {
  static const id = "signup";

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _nameController;
  late AuthProvider _authProvider;
  late ClientProvider _clientProvider;
  late AddressProvider _addressProvider;
  late StoreProvider _marketProvider;
  bool _isVisible = true;
  bool _isValidate = true;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _authProvider = Provider.of<AuthProvider>(context);
    _clientProvider = Provider.of<ClientProvider>(context);
    _addressProvider = Provider.of<AddressProvider>(context);
    _marketProvider = Provider.of<StoreProvider>(context);
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

  _validate() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isValidate = true;
      });
      if (Config.isEmail(_emailController!.text.trim()) &&
          Config.isPassword(_passwordController!.text)) {
        var result = await _authProvider.registerWithEmail(
            _nameController!.text,
            _emailController!.text,
            _passwordController!.text);
        if (result) {
          showTopSnackBar(
              context,
              CustomSnackBar.success(
                  message: "Registration has been completed please sign in !"));
          Navigator.pushReplacementNamed(context, Login.id);
          _authProvider.setBusy(false);
        } else {
          _authProvider.setBusy(false);
          showTopSnackBar(
              context,
              CustomSnackBar.info(
                  message: "The given credentials are exist please\n sign in"));
        }
      } else {}
    } else {
      setState(() {
        _isValidate = false;
      });
    }
  }

  _googleSignUp() async {
    var result = await _authProvider.socialSignUp("google");
    checkErrors(result);
  }

  _facebookSignUp() async {
    var result = await _authProvider.socialSignUp("facebook");
    checkErrors(result);
  }

  checkErrors(bool result) async {
    if (result) {
      await _marketProvider.getStoreType();
      Provider.of<ClientProvider>(context, listen: false)
          .setClient(_authProvider.client!);
      Navigator.pushReplacementNamed(context, Home.id);
      _authProvider.setBusy(false);
    } else {
      _authProvider.setBusy(false);
      showTopSnackBar(
          context,
          CustomSnackBar.info(
              message: "The given credentials are exist please\n sign in"));
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Provider.of<LocaleProvider>(context);
    return _authProvider.isLoading
        ? Loading()
        : Scaffold(
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
                      AppLocalizations.of(context)!.signup,
                      style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600),
                    ).paddingOnly(left: 35, bottom: 10).align(
                        alignment: locale.locale?.languageCode == "ar"
                            ? Alignment.topRight
                            : Alignment.topLeft),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(bottom: 30),
                      height: _isValidate ? 440 : 480,
                      width: screenSize(context).width * .85,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!.join +
                                        "\n",
                                    style: GoogleFonts.ubuntu(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 28,
                                        color: Config.color_1),
                                  ),
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .love_join,
                                      style: GoogleFonts.ubuntu(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
                                          color: Config.color_1))
                                ],
                              )),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Config.google,
                                    onPressed: _googleSignUp,
                                    iconSize: 40),
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  icon: Config.facebook,
                                  onPressed: _facebookSignUp,
                                  iconSize: 40,
                                ),
                              ]),
                          Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  Input(
                                    _nameController!,
                                    AppLocalizations.of(context)!.name,
                                    CupertinoIcons.person,
                                    isName: true,
                                  ),
                                  Input(
                                      _emailController!,
                                      AppLocalizations.of(context)!.email,
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
                              if (_clientProvider.client == null ||
                                  _addressProvider.address == null) {
                                Config.bottomSheet(context);
                              } else {
                                Prefs.instance.setAuth(false);
                                Navigator.pushReplacementNamed(
                                    context, Home.id);
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.skip),
                            style: OutlinedButton.styleFrom(
                                primary: Config.color_1,
                                side: BorderSide(
                                    color: Config.color_1, width: 1.5),
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
