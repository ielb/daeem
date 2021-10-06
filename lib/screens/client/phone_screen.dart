import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneScreen extends StatefulWidget {
  static const id = "phone";

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  late TextEditingController _phoneController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String initialCountry = 'MA';

  PhoneNumber number = PhoneNumber(isoCode: 'MA');
  late ClientProvider client;

  @override
  void initState() {
    _phoneController = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    client = Provider.of<ClientProvider>(context);
    _phoneController.text = client.client?.phone ?? '';
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    client.dispose();
    super.dispose();
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: InternationalPhoneNumberInput(
                        hintText: "please add phone number",
                        maxLength: 10,
                        onInputChanged: (PhoneNumber number) {
                          print(number.phoneNumber);
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
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
                          print('On Saved: $number');
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
              child: Text("Done",
                  style: GoogleFonts.ubuntu(
                      fontSize: 24,
                      color: Config.color_1,
                      fontWeight: FontWeight.w600)),
              onPressed: () {},
            ).align(alignment: Alignment.bottomCenter),
          ],
        ),
      ),
    );
  }
}
