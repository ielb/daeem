import 'dart:io';

import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/provider/notifiation_provider.dart';
import 'package:daeem/screens/login.dart';
import 'package:daeem/screens/notification_screen.dart';
import 'package:daeem/screens/order_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _clientProvider = Provider.of<AuthProvider>(context);
    var _client = Provider.of<ClientProvider>(context);
    var _store = Provider.of<StoreProvider>(context);
    var _notificationProvider = Provider.of<NotificationProvider>(context);
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
                    icon: Icon(
                      Ionicons.bag_handle,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(OrdersPage.id)),
                container(
                    label: "My information",
                    icon: Icon(
                      Ionicons.person,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () {
                      print('TEST');
                      Navigator.of(context).pushNamed(Profile.id);
                    }),
                Divider(),
                container(
                    label: "Notifications",
                    icon: Icon(
                      Ionicons.notifications,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, NotificationScreen.id);
                    }),
                container(
                    label: "Rate us",
                    icon: Icon(
                      Ionicons.star,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () {
                      rateUs();
                    }),
                container(
                    label: "Refer a friend",
                    icon: Icon(
                      Ionicons.share_social,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () {
                      shareApp();
                    }),
                container(
                    label: "Help",
                    icon: Icon(
                      Ionicons.help_circle,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () {}),
                Spacer(),
                container(
                    label: "Log out",
                    icon: Icon(
                      Ionicons.log_out_outline,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Log out",
                                style: GoogleFonts.ubuntu(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                "Are you sure you want to log out?",
                                style: GoogleFonts.ubuntu(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    "Log out",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 20, color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    _notificationProvider.clearNotifications();
                                    var result = await _clientProvider.logOut();
                                    Provider.of<AddressProvider>(context,listen:false).setAddress(null);
                                    if (result) {
                                      Navigator.of(context).pushNamed(Login.id);
                                      _client.clear();
                                      _store.clear();
                                    }
                                  },
                                )
                              ],
                            );
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
                    label: "Sign in",
                    icon: Icon(
                      Ionicons.log_in_outline,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () {
                      _store.clear();
                      Navigator.of(context).pushReplacementNamed(Login.id);
                    }),
                Divider(),
                container(
                    label: "Rate us",
                    icon: Icon(
                      Ionicons.star,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () {
                      rateUs();
                    }),
                container(
                    label: "Refer a friend",
                    icon: Icon(
                      Ionicons.share_social,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () {
                      shareApp();
                    }),
                container(
                    label: "Help",
                    icon: Icon(
                      Ionicons.help_circle,
                      size: 28,
                      color: Config.darkBlue,
                    ),
                    onPressed: () {}),
                Spacer(),
              ],
            ),
    );
  }

  shareApp() async {
    await Share.share(
        "Get free delivery for 3 days by downloading Daeem  Play store :  ${Config.playStoreUrl} Appstore : ${Config.appStoreUrl} ");
  }

  rateUs() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      if (Platform.isIOS) {
        await inAppReview.requestReview();
      } else {
        await inAppReview.requestReview();
      }
    }
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
            if (label != "Log out")
              Icon(
                CupertinoIcons.right_chevron,
                color: Colors.black54,
                size: 16,
              ).paddingOnly(right: 10)
          ],
        ),
      ).center(),
      onPressed: onPressed,
    ).paddingOnly(left: 15);
  }
}
