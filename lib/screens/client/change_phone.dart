import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/screens/client/phone_verification.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ChangePhone extends StatefulWidget {
  static const id = "phone";

  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  late TextEditingController _phoneController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String initialCountry = 'MA';
  bool enter = false;

  PhoneNumber number = PhoneNumber(isoCode: 'MA');
  late ClientProvider client;

  @override
  void initState() {
    _phoneController = TextEditingController();

    super.initState();
  }

  String? phoneNumber;

  @override
  void didChangeDependencies() {
    if (!enter) {
      client = Provider.of<ClientProvider>(context);
      _phoneController.text = client.client?.phone?.substring(4,(client.client?.phone?.length??2-1)) ?? '';
      setState(() {
        enter = true;
      });
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool isNumber() {
    if (_phoneController.text.startsWith("05") ||
        _phoneController.text.startsWith("07") ||
        _phoneController.text.startsWith("06") &&
            _phoneController.text.length == 10)
      return true;
    else
      return false;
  }

  _change() {
    bool result = formKey.currentState?.validate() ?? false;

    if (_phoneController.text != '' && isNumber() && result) {
      formKey.currentState?.save();
     
      Navigator.pushNamed(context, Verification.id,arguments: phoneNumber ?? _phoneController.text);
    } else
      showTopSnackBar(
          context,
          CustomSnackBar.error(
              message: "The format of  provided number is wrong! "));
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
            Navigator.pop(context);
          },
          color: Config.black,
        ),
        title: Text("Update phone number",
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
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                 
                    Container(
                      child: InternationalPhoneNumberInput(
                        hintText: "please add phone number",
                        maxLength: 10,
                        onInputChanged: (PhoneNumber number) {},
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: number,
                        textFieldController: _phoneController,
                        formatInput: false,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        onSaved: (PhoneNumber number) {
                          setState(() {
                            phoneNumber = number.phoneNumber;
                          });
                        },
                      ),
                    ).paddingAll(30),
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
              child: Text("Submit",
                  style: GoogleFonts.ubuntu(
                      fontSize: 24,
                      color: Config.color_1,
                      fontWeight: FontWeight.w600)),
              onPressed: () {
                _change();
              },
            ).align(alignment: Alignment.bottomCenter),
          ],
        ),
      ),
    );
  }
}
