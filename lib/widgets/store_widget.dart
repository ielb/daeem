import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/services/services.dart';

class StoreWidget extends StatelessWidget {
  StoreWidget({required this.title, required this.imageUrl});
  final title;
  final imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child:
            CachedNetworkImage(
                    imageUrl: imageUrl,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(
                                value: downloadProgress.progress).paddingOnly(bottom: 10)
                            .center(),
                    errorWidget: (context, url, error) => Image.asset(
                          "assets/placeholder.png",
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        )),
          ),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: GoogleFonts.ubuntu(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ).align(alignment: Alignment.center).paddingOnly(top:4,),
        ],
      ),
    );
  }
}
