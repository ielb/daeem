import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class HomeCategory extends StatelessWidget {
  const HomeCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            print("tapped");
          },
          dense: true,
          isThreeLine: true,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              Config.margane,
              height: 50,
              width: 50,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            "Carrefour",
            style: GoogleFonts.ubuntu(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
          ).paddingOnly(top: 5),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address",
                style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "time",
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
