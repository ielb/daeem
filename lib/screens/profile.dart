import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/screens/client/change_address.dart';
import 'package:daeem/screens/client/change_password.dart';
import 'package:daeem/screens/client/change_phone.dart';
import 'package:daeem/screens/home.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const id = "profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _nameController, _emailController;
  late ClientProvider _clientProvider;
  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    WidgetsBinding.instance!.scheduleFrameCallback((timeStamp) {
      _clientProvider = Provider.of<ClientProvider>(context, listen: false);
      _nameController.text = _clientProvider.client!.name!;
      _emailController.text = _clientProvider.client!.email!;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    print("dispose");
    super.dispose();
  }

  Future<bool> _backPressed() async {
    await _clientProvider.updateInfo(
        _nameController.text, _emailController.text);
    setState(() {});
    Navigator.of(context).pushReplacementNamed(Home.id);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
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
          title: Text(AppLocalizations.of(context)!.my_information,
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
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextField(
                      controller: _nameController,
                      style: GoogleFonts.ubuntu(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                          icon: Icon(
                            CupertinoIcons.person,
                            color: Colors.black54,
                            size: 28,
                          ).paddingOnly(left: 15, right: 5),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none))
                  .paddingOnly(right: 20, top: 10),
              TextField(
                      controller: _emailController,
                      style: GoogleFonts.ubuntu(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                          icon: Icon(
                            CupertinoIcons.envelope,
                            color: Colors.black45,
                            size: 24,
                          ).paddingOnly(left: 17, right: 5),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none))
                  .paddingOnly(right: 20, top: 20),
              TextButton(
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.location,
                        color: Colors.black54,
                        size: 28,
                      ),
                      SizedBox(width: 18),
                      Text(
                        "Change Address",
                        style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Spacer(),
                      Icon(
                        CupertinoIcons.right_chevron,
                        color: Colors.black54,
                        size: 18,
                      ).paddingOnly(right: 10)
                    ],
                  ),
                ).center(),
                onPressed: () {
                   Navigator.of(context).pushNamed(ChangeAddress.id);
                },
              ).paddingOnly(left: 7, top: 20),
              TextButton(
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.lock,
                        color: Colors.black54,
                        size: 28,
                      ),
                      SizedBox(width: 18),
                      Text(
                        "Change password",
                        style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Spacer(),
                      Icon(
                        CupertinoIcons.right_chevron,
                        color: Colors.black54,
                        size: 18,
                      ).paddingOnly(right: 10)
                    ],
                  ),
                ).center(),
                onPressed: () {
                  Navigator.of(context).pushNamed(ChangePassword.id);
                },
              ).paddingOnly(left: 7, top: 20),
              TextButton(
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.phone,
                        color: Colors.black54,
                        size: 28,
                      ),
                      SizedBox(width: 18),
                      Text(
                        "Change phone number",
                        style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Spacer(),
                      Icon(
                        CupertinoIcons.right_chevron,
                        color: Colors.black54,
                        size: 18,
                      ).paddingOnly(right: 10)
                    ],
                  ),
                ).center(),
                onPressed: () {
                  Navigator.of(context).pushNamed(ChangePhone.id);
                },
              ).paddingOnly(left: 7, top: 20),
            ],
          ),
        ),
      ),
    );
  }
}
