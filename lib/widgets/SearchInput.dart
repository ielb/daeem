import 'package:daeem/services/services.dart';

class SearchInput extends StatelessWidget {
  const SearchInput(this._controller,this._hint,this._width,this._icon);
  final TextEditingController _controller;
  final String  _hint;
  final IconData _icon ;
  final double _width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width ,
      child: TextFormField(
        controller: _controller,
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
            )),
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
