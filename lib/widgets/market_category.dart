import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(this._categoryTitle, this._categoryImageUrl);
  final String _categoryTitle;
  final String _categoryImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenSize(context).width * .91,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                image: NetworkImage(_categoryImageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 16,
                offset: Offset(0, 4),
              )
            ]),
        child: Text(
          _categoryTitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
          style: GoogleFonts.ubuntu(
              fontSize: 30, fontWeight: FontWeight.w500, color: Config.white),
        ).center());
  }
}
