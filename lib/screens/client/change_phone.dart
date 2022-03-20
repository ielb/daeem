import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/screens/client/phone_verification.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class ChangePhone extends StatefulWidget {
  static const id = "phone";

  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  late TextEditingController _phoneController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool enter = false;
  int from = 0;

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
      from = ModalRoute.of(context)?.settings.arguments as int;
      client = Provider.of<ClientProvider>(context);
      _phoneController.text = client.client?.phone
              ?.substring(4, (client.client?.phone?.length ?? 2 - 1)) ??
          '';
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
            _phoneController.text.length == 10 ||
        _phoneController.text.length == 9)
      return true;
    else
      return false;
  }

  _change() async {
    bool result = formKey.currentState?.validate() ?? false;

    if (_phoneController.text != '' && isNumber() && result) {
      await client
          .verifyClientPhoneNumber(phoneNumber ?? _phoneController.text);

      Navigator.pushReplacementNamed(context, Verification.id, arguments: {
        'phoneNumber':
            "+212${_phoneController.text.length == 9 ? _phoneController.text : _phoneController.text.substring(1)}",
        'from': from
      });
    }
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
                    SizedBox(
                      height: screenSize(context).height * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Enter your new phone number",
                        style: GoogleFonts.ubuntu(
                            color: Config.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: screenSize(context).height * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _phoneController,
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          paste: true,
                          selectAll: true,
                        ),
                        textInputAction: TextInputAction.done,
                        validator: (number) {
                          if (number != null && number.isEmpty) {
                            return "Please enter your phone number";
                          } else if (!isNumber()) {
                            return "Please enter a valid phone number";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            phoneNumber = value;
                            _change();
                          });
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            phoneNumber = value;
                            _change();
                          });
                        },
                        style: GoogleFonts.ubuntu(
                            color: Config.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          prefixIcon: SizedBox(
                              width: 0,
                              child: Text(
                                "+212",
                                style: GoogleFonts.ubuntu(
                                    color: Config.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ).paddingOnly(bottom: 1).center()),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Config.color_2),
                              borderRadius: BorderRadius.circular(15)),
                          enabled: true,
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(15)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Config.color_2),
                              borderRadius: BorderRadius.circular(15)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Config.color_2),
                              borderRadius: BorderRadius.circular(15)),
                          labelText: 'Phone number',
                          labelStyle: GoogleFonts.ubuntu(
                              color: Config.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _change();
          },
          child: Container(
            child: Text(
              "Next",
              style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ).center(),
            decoration: BoxDecoration(
              color: Config.color_1,
              borderRadius: BorderRadius.circular(15),
            ),
            width: screenSize(context).width * .9,
            height: 50,
          ).align(alignment: Alignment.bottomCenter).paddingOnly(bottom: 10),
        ),
      ),
    );
  }
}
