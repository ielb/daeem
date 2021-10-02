import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/screens/login.dart';
import 'package:daeem/screens/order_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _clientProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      height: screenSize(context).height,
      width: screenSize(context).width * .8,
      color: Colors.white,
      child: _clientProvider.isAuth()
          ? Column(
              children: [
                Container(
                  height: 150,
                  width: screenSize(context).width,
                  color: Config.darkBlue,
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(CupertinoIcons.clear),
                        iconSize: 26,
                        color: Config.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                          .paddingOnly(top: 35)
                          .align(alignment: Alignment.topRight),
                      Image.asset(
                        Config.logo_white,
                      ).center().paddingOnly(top: 20),
                    ],
                  ),
                ),
                Text("Account",
                        style: GoogleFonts.ubuntu(
                            color: Config.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 26))
                    .align(alignment: Alignment.topLeft)
                    .paddingOnly(top: 20, left: 20),
                SizedBox(
                  height: screenSize(context).height * .05,
                ),
                container(
                    label: "My orders",
                    icon: Config.shoppingBag,
                    onPressed: () =>  Navigator.of(context).pushNamed(OrdersPage.id)
                    ),
                container(
                    label: "My information",
                    icon: Config.user,
                    onPressed: () {
                      print('TEST');Navigator.of(context).pushNamed(Profile.id);}),
                Divider(),
                container(
                    label: "Notifications",
                    icon: Config.notification,
                    onPressed: () {}),
                container(
                    label: "Rate us", icon: Config.rate, onPressed: () {}),
                container(
                    label: "Refer a friend",
                    icon: Config.share,
                    onPressed: () {}),
                container(
                    label: "Help", icon: Config.question, onPressed: () {}),
                Spacer(),
                container(
                    label: "Log out",
                    icon: Config.logout,
                    onPressed: () {
                      _clientProvider.logOut().then((result) {
                        print(result);
                        if (result) {
                          Navigator.of(context).pushReplacementNamed(Login.id);
                        }
                      });
                    }).paddingOnly(bottom: 20)
              ],
            )
          : Column(
              children: [
                Container(
                  height: 150,
                  width: screenSize(context).width,
                  color: Config.darkBlue,
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(CupertinoIcons.clear),
                        iconSize: 26,
                        color: Config.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                          .paddingOnly(top: 35)
                          .align(alignment: Alignment.topRight),
                      Image.asset(
                        Config.logo_white,
                      ).center().paddingOnly(top: 20),
                    ],
                  ),
                ),
                Text("Account",
                        style: GoogleFonts.ubuntu(
                            color: Config.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 26))
                    .align(alignment: Alignment.topLeft)
                    .paddingOnly(top: 20, left: 20),
                SizedBox(
                  height: screenSize(context).height * .05,
                ),
                container(
                    label: "Sign in", icon: Config.user, onPressed: () {}),
              ],
            ),
    );
  }

  Widget container(
      {required String label,
      required Widget icon,
      required Function()? onPressed}) {
    return TextButton(
      child: Container(
        child: Row(
          children: [
            icon,
            SizedBox(width: 20),
            Text(label,
                style: GoogleFonts.ubuntu(
                    color: Config.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18)),
                    Spacer(),
           if(label!="Log out") Icon(CupertinoIcons.right_chevron,color: Colors.black54,size: 16,).paddingOnly(right: 10)
          ],
        ),
      ).center(),
      onPressed: onPressed,
    ).paddingOnly(left: 15);
  }
}
