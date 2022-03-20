import 'package:daeem/screens/order_screen.dart';
import 'package:daeem/services/services.dart';

class ConfirmedPage extends StatefulWidget {
  static const id = "confirmed";

  @override
  _ConfirmedPageState createState() => _ConfirmedPageState();
}

class _ConfirmedPageState extends State<ConfirmedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Image.asset("assets/confirmed.png")
                .paddingOnly(top: 80, bottom: 50, left: 50, right: 50),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Your Order is on the way\n\n",
                  style: GoogleFonts.ubuntu(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                  children: [
                    TextSpan(
                        text:
                            "Thank you for yor order you can track the delivery in order section",
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.black54))
                  ]),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                ///Todo:add track
                Navigator.pushReplacementNamed(context, OrdersPage.id);
              },
              child: Text(
                "Track order",
                style: GoogleFonts.ubuntu(fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                  shadowColor: Config.color_1,
                  primary: Config.color_1,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15),
                  ),
                  fixedSize: Size(screenSize(context).width * .8, 50)),
            ).align(alignment: Alignment.bottomCenter),
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Home.id);
              },
              child: Text("Back home"),
              style: OutlinedButton.styleFrom(
                  primary: Config.color_1,
                  side: BorderSide(color: Config.color_1, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15),
                  ),
                  textStyle: GoogleFonts.ubuntu(fontSize: 20),
                  fixedSize: Size(screenSize(context).width * .8, 50)),
            ).paddingOnly(top: 20, bottom: 50),
          ],
        ),
      ),
    );
  }
}
