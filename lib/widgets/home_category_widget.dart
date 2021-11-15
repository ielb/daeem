import 'package:daeem/models/market.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class HomeCategory extends StatelessWidget {
  const HomeCategory({required this.store,key}) : super(key: key);
  final Store store;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Provider.of<StoreProvider>(context,listen: false).setCurrentMarket(store);
            Navigator.pushNamed(context, MarketPage.id,arguments: store);
          },
          dense: true,
          isThreeLine: true,
          leading: Image.network(
            store.logo??'',
            height: 50,
            width: 50,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
          ),
          title: Text(
            "${store.name??''}",
            style: GoogleFonts.ubuntu(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
          ).paddingOnly(top: 5),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${store.address??''}",
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
