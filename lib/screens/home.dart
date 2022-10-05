// ignore_for_file: must_be_immutable

import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/provider/notifiation_provider.dart';
import 'package:daeem/screens/client/add_address.dart';
import 'package:daeem/screens/notification_screen.dart';
import 'package:daeem/screens/store/home_store_shimmer.dart';
import 'package:daeem/screens/store_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/home_category_widget.dart';
import 'package:daeem/widgets/store_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

class Home extends StatefulWidget {
  static const id = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late ClientProvider _clientProvider;
  late AddressProvider _addressProvider;
  bool called = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!called) {
      if (mounted)
        setState(() {
          called = true;
        });
      _clientProvider = Provider.of<ClientProvider>(context);
      _addressProvider = Provider.of<AddressProvider>(context);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_clientProvider.client?.address == null &&
            _addressProvider.address == null) {
          Config.bottomSheet(context);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _requiestPop() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Are you sure you want to exit?',
          style: GoogleFonts.ubuntu(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'No',
              style: GoogleFonts.ubuntu(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text(
              'Yes',
              style: GoogleFonts.ubuntu(color: Colors.red),
            ),
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          ),
        ],
      ),
    );
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requiestPop,
      child: Scaffold(
        key: _key,
        drawer: CustomDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AddressPage.id);
            },
            child: SizedBox(
              width: screenSize(context).width * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Delivering to",
                    style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade500),
                  ).align(alignment: Alignment.topLeft),
                  Row(
                    children: [
                      SizedBox(
                        width: screenSize(context).width * .35,
                        child: Consumer<ClientProvider>(
                            builder: (context, _provider, child) {
                          return Text(
                            "${_provider.client?.address?.address ?? 'current Location'}",
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ubuntu(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Config.darkBlue),
                          );
                        }),
                      ),
                      Icon(
                        CupertinoIcons.chevron_down,
                        color: Config.color_2,
                        size: 18,
                      ).paddingOnly(left: 5, top: 5)
                    ],
                  ),
                ],
              ),
            ),
          ),
          leading: IconButton(
              onPressed: () {
                _key.currentState!.openDrawer();
              },
              icon: Icon(
                Ionicons.menu,
                size: 28,
                color: Config.darkBlue,
              )),
          automaticallyImplyLeading: false,
          actions: [
            Consumer<NotificationProvider>(builder: (contex, _notif, child) {
              return Stack(children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, NotificationScreen.id);
                    },
                    icon: Icon(
                      Ionicons.notifications,
                      size: 28,
                      color: Config.darkBlue,
                    )),
                Visibility(
                  visible: _notif.notifications.length != 0,
                  child: Positioned(
                    right: 3,
                    top: 2,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          '${_notif.notifications.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              ]);
            }),
          ],
        ),
        body: Consumer<StoreProvider>(builder: (context, _provider, child) {
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Consumer<ClientProvider>(
                    builder: (context, _client, child) {
                  return Text(
                    "Ahlan, ${_client.client?.name ?? 'Visitor'} !",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                      .paddingOnly(top: 10, left: 15)
                      .align(alignment: Alignment.topLeft);
                }),
              ),
              _Content(provider: _provider),
              _Section(
                provider: _provider,
              )
            ],
          );
        }),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({required this.provider, Key? key}) : super(key: key);
  StoreProvider provider;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      height: 165,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What are you looking for ?",
            style: GoogleFonts.ubuntu(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400),
          ).paddingOnly(bottom: 10, left: 15),
          Container(
            height: 120,
            child: FutureBuilder(
                future: Future(() => false),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return StoreShimmer().paddingOnly(left: 10, right: 10);
                      },
                    );
                  }
                  if (provider.storesType.length == 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return StoreShimmer().paddingOnly(left: 15, right: 15);
                      },
                    );
                  }
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    itemExtent: 100,
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.storesType.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                          onTap: () {
                            provider.setStoreType(provider.storesType[i].name);
                            Navigator.pushNamed(context, Store.id,
                                arguments: provider.storesType[i].id);
                          },
                          child: StoreWidget(
                              title: "${provider.storesType[i].name}",
                              imageUrl: provider.storesType[i].image));
                    },
                  ).paddingOnly(left: 10);
                }),
          ),
        ],
      ),
    ));
  }
}

class _Section extends StatelessWidget {
  _Section({required this.provider, Key? key}) : super(key: key);
  StoreProvider provider;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: FutureBuilder(
            future: Future(() => false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator(
                  color: Config.color_2,
                ).paddingOnly(top: 100).center();
              if (provider.storesType.length == 0) {
                return CircularProgressIndicator(
                  color: Config.color_2,
                ).paddingOnly(top: 100).center();
              } else
                return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: provider.storesType.length,
                    itemBuilder: (context, index) {
                      return provider.storesType[index].stores.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${provider.storesType[index].name}",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ).paddingOnly(bottom: 10, left: 15),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: provider.storesType[index]
                                                  .stores.length >=
                                              3
                                          ? 3
                                          : provider
                                              .storesType[index].stores.length,
                                      itemBuilder: (context, i) {
                                        return HomeCategory(
                                            store: provider
                                                .storesType[index].stores[i]);
                                      }),
                                  if (provider.storesType[index].stores.length >
                                      3)
                                    InkWell(
                                      onTap: () {
                                        provider.setStoreType(
                                            provider.storesType[index].name);
                                        Navigator.pushNamed(context, Store.id,
                                            arguments:
                                                provider.storesType[index].id);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: screenSize(context).width * .75,
                                        decoration: BoxDecoration(
                                            color: Config.color_2,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "View more (${provider.storesType[index].stores.length - 3})",
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 22,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ),
                                    ).align(
                                      alignment: Alignment.center,
                                    )
                                ],
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            );
                    });
            }));
  }
}
