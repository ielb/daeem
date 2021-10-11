import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(this._categoryTitle, this._categoryImageUrl);
  final String _categoryTitle;
  final String _categoryImageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: screenSize(context).width * .91,
          height: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
                imageUrl: _categoryImageUrl,
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: Colors.black.withOpacity(0.3),
                
              
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress)
                        .center(),
                errorWidget: (context, url, error) => Image.asset(
                      "assets/placeholder.png",
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    )),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 16,
                  offset: Offset(0, 4),
                )
              ]),
        ),
        Text(
          _categoryTitle,
          softWrap: true,
          style: GoogleFonts.ubuntu(
              fontSize: 24, fontWeight: FontWeight.w500, color: Config.white),
        ).paddingOnly(top: 10, left: 10)
      ],
    );
  }
}
