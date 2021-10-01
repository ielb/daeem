import 'package:flutter/cupertino.dart';
import 'package:daeem/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  Input(this._controller, this._hint, this._icon,
      {this.isName=false,this.isPassword = false, this.showPassword,this.isNumber=false, this.obscureText = false});

  final String _hint;
  final IconData _icon;
  final bool isName;
  final bool obscureText;
  final bool isPassword;
  final bool isNumber;
  final TextEditingController _controller;
  final Function()? showPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      child: TextFormField(
        validator: (content){
          if(!isName){

          if(isPassword==false&&!isNumber){
           bool result  =  Config.isEmail(_controller.text.trim());
             if(!result){
              return "Please provide a valid email";}
          }else{
            if(isPassword) {
              bool result = _controller.text.length>=8 ? true : false;
              if (!result) {
                return "Please provide a valid password >= 8";
              }
            }else{
              return "Please provide a valid phone number";
            }
          }
          }
        },
        controller: _controller,
        obscureText: obscureText,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          errorStyle:     GoogleFonts.ubuntu(color: Colors.red, fontSize: 12),
            contentPadding: EdgeInsets.all(1),
            filled: true,
            fillColor: Config.lightGray,
            hintText: _hint,
            hintStyle:
                GoogleFonts.ubuntu(color: Colors.grey[400], fontSize: 16),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
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
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                        obscureText ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_solid),
                    onPressed: showPassword,
                    iconSize: 20,
                    color: Config.color_1,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            prefixIcon: Icon(
              _icon,
              color: Colors.grey[350],
            )),
      ),
    ).paddingOnly(bottom: 10);
  }
}
