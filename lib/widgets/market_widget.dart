import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/models/market.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/rating.dart';
import 'package:flutter/cupertino.dart';

class MarketWidget extends StatelessWidget {
  const MarketWidget({required this.store,required this.onRate});
  final Store store;
  final Function(int) onRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize(context).width * .91,
      height: 274,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 2,
              blurRadius: 16,
              offset: Offset(0, 4),
            )
          ]),
      child: Column(
        children: [
          Container(
              height: 135,
              width: screenSize(context).width * .91,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                    imageUrl: store.cover!,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    memCacheHeight: 80,
                    
                    
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(
                                value: downloadProgress.progress)
                            .center(),
                    errorWidget: (context, url, error) => Image.asset(
                          "assets/placeholder.png",
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        )),
              )).paddingOnly(bottom: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: new Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    store.name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                    style: GoogleFonts.ubuntu(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff4A4B4D)),
                  ),
                ),
              ),
              Rating(onRate, store.isFakeRating! ? 5 : store.rating!).paddingOnly(right: 10),
            ],
          ).paddingOnly(bottom: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(CupertinoIcons.location,
                          size: 18, color: Color(0xff4A4B4D)),
                      Container(
                        width: 150,
                        child: Text(store.address!,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ubuntu(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff4A4B4D))),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(CupertinoIcons.clock,
                              size: 18, color: Color(0xff4A4B4D))
                          .paddingOnly(right: 3),
                      Text(store.hours,
                          style: GoogleFonts.ubuntu(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff4A4B4D))),
                      SizedBox(
                        width: 55,
                      ),
                    ],
                  )
                ],
              ),
              Spacer(),
              Container(
                height: 30,
                width: 80,
                child: Text(
                  store.status! ? "Available" : "Closed",
                  style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ).center(),
                decoration: BoxDecoration(
                    color: store.status! ? Config.color_1 : Config.yellow,
                    borderRadius: BorderRadius.circular(10)),
              ).paddingOnly(right: 15, top: 5)
            ],
          ).paddingOnly(top: 5, left: 8)
        ],
      ),
    );
  }
}

