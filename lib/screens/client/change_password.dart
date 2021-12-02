import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  static const id = "password";
  ChangePassword({this.client});
  final Client? client;
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController _currentPasswordController,
      _newPasswordController,
      _confirmPasswordController;
  late ClientProvider _clientProvider;
  bool newPasswordVisible = true;
  bool confirmPasswordVisible = true;
  bool currentPasswordVisible = true;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    WidgetsBinding.instance!.scheduleFrameCallback((timeStamp) {
      _clientProvider = Provider.of<ClientProvider>(context, listen: false);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  _resetPassword() async {
    Config.loading(context);
    if (_formkey.currentState!.validate()) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        var result = await _clientProvider.resetPassword(
            widget.client!, _newPasswordController.text);
        if (result) {
          Navigator.pop(context);
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  elevation: 3,
                  title: Text(
                    "Success",
                    style: GoogleFonts.ubuntu(fontSize: 18),
                  ),
                  content: Text(
                    "Password has changed please sign in!",
                    style: GoogleFonts.ubuntu(fontSize: 18),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Login.id);
                      },
                      child: Text(
                        "Sign in!",
                        style: GoogleFonts.ubuntu(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          shadowColor: Config.color_1,
                          primary: Config.color_1,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15),
                          ),
                          fixedSize: Size(100, 35)),
                    ).paddingOnly(top: 5, bottom: 10),
                  ],
                );
              });
        }
      } else {
        Navigator.pop(context);

        Toast.show("Passwords don't match", context, duration: 5);
      }
    }
  }

  _changePassword() async {
    Config.loading(context);
    var result = _formkey.currentState?.validate();
    print(result);
    if (result != null) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        bool? test = await _clientProvider.changePassword(
          _currentPasswordController.text,
          _newPasswordController.text,
        );
        if (test != null) if (test) {
          Navigator.pop(context);
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  elevation: 3,
                  title: Text(
                    "Success",
                    style: GoogleFonts.ubuntu(fontSize: 18),
                  ),
                  content: Text(
                    "Password has changed !",
                    style: GoogleFonts.ubuntu(fontSize: 18),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Login.id);
                      },
                      child: Text(
                        "Back",
                        style: GoogleFonts.ubuntu(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          shadowColor: Config.color_1,
                          primary: Config.color_1,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15),
                          ),
                          fixedSize: Size(100, 35)),
                    ).paddingOnly(top: 5, bottom: 10),
                  ],
                );
              });
        } else {
          Navigator.pop(context);
          Toast.show(
              "Your current password is incorrect. Please try again", context,
              duration: 5);
        }
        else
          Toast.show("Something went wrong", context, duration: 5);
      } else {
        Toast.show("Passwords don't match", context, duration: 5);
      }
    }
  }

  String? validate(String? text) {
    if (text != null && text.isEmpty) return 'this field is required';
    if (text != null && text.length < 8)
      return 'the password should be 8 chars long';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Config.white,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Config.black,
        ),
        title: Text(
            widget.client != null ? "Reset password" : "Update password",
            style: GoogleFonts.ubuntu(
                color: Config.black,
                fontSize: 22,
                fontWeight: FontWeight.w500)),
        elevation: 4,
        shadowColor: Colors.black38,
      ),
      bottomNavigationBar: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(35),
          shadowColor: MaterialStateProperty.all(Colors.black),
          fixedSize:
              MaterialStateProperty.all(Size(screenSize(context).width, 50)),
        ),
        child: Text(widget.client != null ? "Reset" : "Update",
            style: GoogleFonts.ubuntu(
                fontSize: 24,
                color: Config.color_1,
                fontWeight: FontWeight.w600)),
        onPressed: () {
          if (widget.client != null)
            _resetPassword();
          else
            _changePassword();
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenSize(context).height,
          width: screenSize(context).width,
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Visibility(
                    visible: widget.client != null ? false : true,
                    child: Column(children: [
                      Text(
                        "CURRENT PASSWORD",
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      )
                          .align(alignment: Alignment.topLeft)
                          .paddingOnly(left: 20, top: 20),
                      TextFormField(
                          controller: _currentPasswordController,
                          validator: validate,
                          obscureText: currentPasswordVisible,
                          style: GoogleFonts.ubuntu(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                              hintText: "Current password",
                              suffixIcon: InkWell(
                                child: Icon(
                                  currentPasswordVisible
                                      ? CupertinoIcons.eye_slash_fill
                                      : CupertinoIcons.eye_solid,
                                  size: 20,
                                  color: Config.color_1,
                                ),
                                onTap: () {
                                  setState(() {
                                    currentPasswordVisible =
                                        !currentPasswordVisible;
                                  });
                                },
                              ))).paddingOnly(
                        left: 20,
                        right: 20,
                      ),
                    ])),
                Text(
                  "NEW PASSWORD",
                  style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                )
                    .align(alignment: Alignment.topLeft)
                    .paddingOnly(left: 20, top: 20),
                TextFormField(
                    controller: _newPasswordController,
                    validator: validate,
                    obscureText: newPasswordVisible,
                    style: GoogleFonts.ubuntu(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        hintText: "New password",
                        suffixIcon: InkWell(
                          child: Icon(
                            newPasswordVisible
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_solid,
                            size: 20,
                            color: Config.color_1,
                          ),
                          onTap: () {
                            setState(() {
                              newPasswordVisible = !newPasswordVisible;
                            });
                          },
                        ))).paddingOnly(left: 20, right: 20),
                Text(
                  "CONFIRM PASSWORD",
                  style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                )
                    .align(alignment: Alignment.topLeft)
                    .paddingOnly(left: 20, top: 20),
                TextFormField(
                    controller: _confirmPasswordController,
                    validator: validate,
                    obscureText: confirmPasswordVisible,
                    style: GoogleFonts.ubuntu(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        hintText: "Confirm password",
                        suffixIcon: InkWell(
                          child: Icon(
                            confirmPasswordVisible
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_solid,
                            size: 20,
                            color: Config.color_1,
                          ),
                          onTap: () {
                            setState(() {
                              confirmPasswordVisible = !confirmPasswordVisible;
                            });
                          },
                        ))).paddingOnly(left: 20, right: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
