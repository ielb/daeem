import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/services/services.dart';
import 'package:ionicons/ionicons.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({required this.product,required this.onTap});
  final Product product;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 4),
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 5),
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: product.image ?? '',
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                      value: downloadProgress.progress)
                                  .center(),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/placeholder.png",
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                      height: 80,
                      width: 80,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 140,
                    child: Text("${product.name}",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ubuntu(
                              color: Colors.black,
                                fontSize: 18, fontWeight: FontWeight.w500))
                        .paddingOnly(left: 5),
                  ),
                  Text("${product.price} DH",
                          style: GoogleFonts.ubuntu(
                              color: Colors.grey,
                              fontSize: 16, fontWeight: FontWeight.w500))
                      .paddingOnly(left: 5),
                ],
              ),
              Spacer(),
              Container(
                child: Icon(
                  Ionicons.chevron_forward,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              ).paddingOnly(right: 10),
              
              
            ],
          ),
        ),
      ),
    );
  }
}