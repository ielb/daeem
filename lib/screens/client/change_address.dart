// ignore_for_file: unused_field

import 'package:daeem/models/address.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';

class ChangeAddress extends StatefulWidget {
  static const id = "address";

  @override
  _ChangeAddressState createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  late TextEditingController _street, _number, _business, _floor, _post;
  late ClientProvider _clientProvider;
  bool _called = false;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    _street = TextEditingController();
    _number = TextEditingController();
    _business = TextEditingController();
    _floor = TextEditingController();
    _post = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_called) {
      _clientProvider = Provider.of<ClientProvider>(context, listen: false);
      _street.text = _clientProvider.client!.address?.streetName ?? '';
      _number.text = _clientProvider.client!.address?.houseNumber ?? '';
      _business.text = _clientProvider.client!.address?.buildingName ?? '';
      _floor.text = _clientProvider.client!.address?.floorDoorNumber ?? '';
      _post.text = _clientProvider.client!.address?.codePostal ?? '';
      setState(() {
        _called = true;
      });
    }
    super.didChangeDependencies();
  }

  _updateAddress() async {
    var result = _formkey.currentState!.validate();
    if (result) {
      Address _address = Address(
        streetName: _street.text,
        codePostal: _post.text,
        address: _street.text + _number.text,
        buildingName: _business.text,
        floorDoorNumber: _floor.text,
      );

      await _clientProvider.updateAddress(_address);
    }
  }

  @override
  void dispose() {
    _street.dispose();
    _number.dispose();
    _business.dispose();
    _floor.dispose();
    _post.dispose();
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
            Navigator.of(context).pop();
          },
          color: Config.black,
        ),
        title: Text("Update Address",
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
                    TextFormField(
                            controller: _street,
                            validator: (value) {
                              if (value == null || value == '') {
                                return "Street name  is  required";
                              }
                              return null;
                            },
                            style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                                labelText: "Street name",
                                labelStyle: GoogleFonts.ubuntu(
                                    fontSize: 18, color: Colors.grey.shade500),
                                icon: Icon(
                                  CupertinoIcons.flag,
                                  color: Colors.black54,
                                  size: 28,
                                ).paddingOnly(left: 15, right: 5),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none))
                        .paddingOnly(right: 20, top: 5),
                    TextFormField(
                            controller: _number,
                            style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                                labelText: "Number",
                                labelStyle: GoogleFonts.ubuntu(
                                    fontSize: 18, color: Colors.grey.shade500),
                                icon: Icon(
                                  Ionicons.home_outline,
                                  color: Colors.black54,
                                  size: 28,
                                ).paddingOnly(left: 15, right: 5),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none))
                        .paddingOnly(right: 20, top: 5),
                    TextFormField(
                            controller: _business,
                            style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                                labelText: "Business / Building name",
                                labelStyle: GoogleFonts.ubuntu(
                                    fontSize: 18, color: Colors.grey.shade500),
                                icon: Icon(
                                  Ionicons.business_outline,
                                  color: Colors.black54,
                                  size: 28,
                                ).paddingOnly(left: 15, right: 5),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none))
                        .paddingOnly(right: 20, top: 5),
                    TextFormField(
                            controller: _floor,
                            style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                                labelText: "Floor / Door number",
                                labelStyle: GoogleFonts.ubuntu(
                                    fontSize: 18, color: Colors.grey.shade500),
                                icon: Icon(
                                  Icons.stairs_outlined,
                                  color: Colors.black54,
                                  size: 28,
                                ).paddingOnly(left: 15, right: 5),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none))
                        .paddingOnly(right: 20, top: 5),
                    TextFormField(
                            controller: _post,
                            validator: (value) {
                              return null;
                            },
                            style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                                labelText: "Post code",
                                labelStyle: GoogleFonts.ubuntu(
                                    fontSize: 18, color: Colors.grey.shade500),
                                icon: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black54,
                                  size: 28,
                                ).paddingOnly(left: 15, right: 5),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none))
                        .paddingOnly(right: 20, top: 5),
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
              onPressed: () {
                _updateAddress();
              },
            ).align(alignment: Alignment.bottomCenter),
          ],
        ),
      ),
    );
  }
}
