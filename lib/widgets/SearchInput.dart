import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class SearchInput extends StatelessWidget {
  const SearchInput(this._controller,this._hint,this._width,this._icon,{this.onChanged,this.onSubmit,this.onTap,this.searching=false,this.onClose});
  final TextEditingController _controller;
  final String  _hint;
  final IconData _icon ;
  final double _width;
  final Function(String)? onChanged;
  final Function()? onClose;
  final Function()? onTap;
  final Function(String)? onSubmit;
  final searching;
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: _width ,
      child: TextFormField(
        controller: _controller,
        onChanged: onChanged,
        onTap: onTap,
        onFieldSubmitted: onSubmit,
        decoration: InputDecoration(
            errorStyle:     GoogleFonts.ubuntu(color: Colors.red, fontSize: 12),
            contentPadding: EdgeInsets.all(1),
            filled: true,
            fillColor: Config.white,
            hintText: _hint,
            hintStyle:
            GoogleFonts.ubuntu(color: Colors.grey[400], fontSize: 16),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Config.white,
                width: 1,
              ),
            ),
            focusColor: Config.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Config.white,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Config.white,
                width: 1,
              ),
            ),
            prefixIcon: Icon(
              _icon,
              color: Colors.grey[350],
            ),
            suffixIcon: searching ?  IconButton(icon: Icon(CupertinoIcons.clear),onPressed: onClose,) : Container(height: 0,width: 0,)
        ),
            
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 2,
            blurRadius: 16,
            offset: Offset(0, 4),
          )
        ]
      ),
    ).paddingOnly(bottom: 10);
  }
}
