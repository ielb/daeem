import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/screens/checkout_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ionicons/ionicons.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Verification extends StatefulWidget {
  static const id = "Verification";

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;
  String phoneNumber = '';
  late TextEditingController _pinPutController;
  final _pinPutFocusNode = FocusNode();
  bool called = false;
  String code  = ''; 
  Map<String, dynamic> from = {'phoneNumber': '', "from": 0};
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Config.color_1),
      borderRadius: BorderRadius.circular(5.0),
    );
  }
    // ignore: unused_field
  late Timer _timer;
  late ClientProvider client;
  int _start = 60;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });
    client.verifyClientPhoneNumber(phoneNumber);
    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!called) {
      _pinPutController = TextEditingController();
      client = Provider.of<ClientProvider>(context);
      from = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        phoneNumber = from['phoneNumber'];
        called = !called;
      });
    }
  }

  void _submit(String _code) {
    setState(() {
      code  = _code;
    });
  }

  verify() async {
    showDialog(
        context: context,
        builder: (context) => Center(
                child: CircularProgressIndicator(
              color: Config.color_2,
            )));
    var result = await client.changePhone(smsCode: code, phone: phoneNumber);
    if (result) {
      showTopSnackBar(
          context,
          CustomSnackBar.success(
              message: "Phone number has been successfuly changed"));
      if (from['from'] == 0)
        Navigator.pushReplacementNamed(context, Profile.id);
      else
        Navigator.pushReplacementNamed(context, CheckoutPage.id);
    } else {
      showTopSnackBar(
          context,
          CustomSnackBar.error(
              message: "please try again or check you phone number"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Ionicons.chevron_back),
              color: Colors.black,
              onPressed: () => Navigator.pop(context)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/sms.gif',
                    ),
                    height: 280,
                  ),
                  Text(
                    "Verification",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please enter the 6 digit code sent to \n $phoneNumber",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey.shade500, height: 1.5),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: PinPut(
                      fieldsCount: 6,
                      onSubmit: (String pin) => _submit(pin),
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      selectedFieldDecoration: _pinPutDecoration,
                      followingFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Config.color_1.withOpacity(.5),
                        ),
                      ),
                    ).center(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't resive the OTP?",
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade500),
                      ),
                      TextButton(
                          onPressed: () {
                            if (_isResendAgain) return;
                            resend();
                          },
                          child: Text(
                            _isResendAgain
                                ? "Try again in " + _start.toString()
                                : "Resend",
                            style: TextStyle(color: Colors.blueAccent),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    disabledColor: Colors.grey,
                    onPressed: code.length < 6
                        ? null
                        : () {
                            verify();
                          },
                    color: Config.color_2,
                    minWidth: double.infinity,
                    height: 50,
                    
                    child: _isLoading
                        ? Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 3,
                              color: Config.color_1,
                            ),
                          )
                        : _isVerified
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 30,
                              )
                            : Text(
                                "Verify",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                  )
                ],
              )),
        ));
  }
}
