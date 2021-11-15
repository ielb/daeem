import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/models/item.dart';
import 'package:daeem/services/services.dart';
import 'package:ionicons/ionicons.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      {required this.item,
      required this.onTap,
      required this.onAdd,
      required this.onDelete,
      required this.onRemove});

  final Item item;
  final Function()? onTap;
  final Function(Item, BuildContext) onRemove;
  final Function(Item) onDelete;
  final Function(Item, BuildContext) onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 70,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300.withOpacity(0.5),
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
                      imageUrl: item.product.image ?? '',
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
                      height: 70,
                      width: 70,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 140,
                    child: Text("${item.product.name}",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ubuntu(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500))
                        .paddingOnly(left: 5),
                  ),
                  Text("${item.product.price} DH/${item.product.hasVariant == 1 ? item.product.variants[1].option?.toLowerCase() : 'Item'}",
                          style: GoogleFonts.ubuntu(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                      .paddingOnly(left: 5),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  onRemove(item, context);
                },
                child: Icon(Ionicons.remove),
              ).paddingOnly(right: 10),
              Text("${item.quantity}",
                  style: GoogleFonts.ubuntu(
                      fontSize: 20, fontWeight: FontWeight.w500)),
              InkWell(
                onTap: () {
                  onAdd(item, context);
                },
                child: Icon(Ionicons.add),
              ).paddingOnly(left: 10),
              Spacer(),
              InkWell(
                onTap: () {
                  onDelete(item);
                },
                child: Icon(
                  Ionicons.trash_outline,
                  color: Colors.redAccent,
                ),
              ).paddingOnly(right: 10),
            ],
          ),
        ),
      ),
    );
  }
}
