
import 'package:flutter/cupertino.dart';
import 'package:daeem/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:daeem/services/services.dart';

class Input extends StatelessWidget {
  const Input(this.hint,this.icon);

  final String hint;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return   Container(
      width: 270,
      child:TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(1),
            filled: true,
            fillColor: Config.lightGray,
            hintText: hint,
            hintStyle: GoogleFonts.ubuntu(color: Colors.grey[400],fontSize: 16),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Config.lightGray,
                width: 1,
              ),
            ),
            focusColor: Config.lightGray,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Config.lightGray,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Config.lightGray,
                width: 1,
              ),
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.grey[350],
            )),
      ),
    ).paddingOnly(bottom: 10);
  }
}
