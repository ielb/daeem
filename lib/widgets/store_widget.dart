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
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            height: 70,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
                value: downloadProgress.progress).paddingOnly(bottom: 10).center(),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/placeholder.png",
                  fit: BoxFit.cover,
                )
          ),
          Text(
            title.toString().replaceAll(r' ', '\n'),
            overflow: TextOverflow.ellipsis,
            textAlign:TextAlign.center,
            softWrap: true,
            style: GoogleFonts.ubuntu(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ).align(alignment: Alignment.center).paddingOnly(top:4,),
        ],
      ),
    );
  }
}
