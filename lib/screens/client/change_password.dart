import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  static const id = "password";
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController _currentPasswordController,
      _newPasswordController,
      _confirmPasswordController;
  late ClientProvider _clientProvider;

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

  _changePassword() async {
    var result = _formkey.currentState?.validate();
    print(result);
    if (result!=null) {
      if (_newPasswordController.text == _confirmPasswordController.text){
      String? test =  await _clientProvider.changePassword(
            _currentPasswordController.text, _newPasswordController.text);
            if(test!=null)
            Toast.show(test, context,duration: 5);
            else
            Toast.show("Something went wrong", context,duration: 5);
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
        title: Text("Update password",
            style: GoogleFonts.ubuntu(
                color: Config.black,
                fontSize: 22,
                fontWeight: FontWeight.w500)),
        elevation: 4,
        shadowColor: Colors.black38,
      ),
      body: Container(
        height: screenSize(context).height,
        width: screenSize(context).width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
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
                        style: GoogleFonts.ubuntu(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          hintText: "Current password",
                        )).paddingOnly(
                      left: 20,
                      right: 20,
                    ),
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
                        style: GoogleFonts.ubuntu(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          hintText: "New password",
                        )).paddingOnly(left: 20, right: 20),
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
                        style: GoogleFonts.ubuntu(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          hintText: "Confirm password",
                        )).paddingOnly(left: 20, right: 20),
                  ],
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                elevation: MaterialStateProperty.all(35),
                shadowColor: MaterialStateProperty.all(Colors.black),
                fixedSize: MaterialStateProperty.all(
                    Size(screenSize(context).width, 50)),
              ),
              child: Text("Update",
                  style: GoogleFonts.ubuntu(
                      fontSize: 24,
                      color: Config.color_1,
                      fontWeight: FontWeight.w600)),
              onPressed: () { _changePassword();},
            ).align(alignment: Alignment.bottomCenter),
          ],
        ),
      ),
    );
  }
}
