import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/models/market.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class HomeCategory extends StatelessWidget {
  const HomeCategory({required this.store, key}) : super(key: key);
  final Store store;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Provider.of<StoreProvider>(context, listen: false)
                .setCurrentMarket(store);
            Navigator.pushNamed(context, MarketPage.id, arguments: store);
          },
          dense: true,
          isThreeLine: true,
          leading: CachedNetworkImage(
            imageUrl: store.logo ?? '',
            height: 50,
            width: 50,
            memCacheHeight: 55,
            fit: BoxFit.contain,
            errorWidget: (context, url, error) =>
                Image.asset(Config.placeHolder),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(
              value: downloadProgress.progress,
              color: Config.color_2,
              strokeWidth: 2,
            ).center(),
          ),
          title: Text(
            "${store.name ?? ''}",
            style: GoogleFonts.ubuntu(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
          ).paddingOnly(top: 5),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${store.address ?? ''}",
                style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "${store.hours}",
                style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          trailing: Icon(CupertinoIcons.chevron_right),
        ),
        Divider(
          thickness: 0.8,
        )
      ],
    );
  }
}
