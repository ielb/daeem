import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/client/add_address.dart';
import 'package:daeem/screens/notification_screen.dart';
import 'package:daeem/screens/store/home_store_shimmer.dart';
import 'package:daeem/screens/store_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/drawer.dart';
import 'package:daeem/widgets/home_category_widget.dart';
import 'package:daeem/widgets/store_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  static const id = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "John";
  double value = 3.5;
  int itemCount = 5;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late StoreProvider marketProvider;
  late ClientProvider _clientProvider;
  late AddressProvider _addressProvider;
  bool isSearching = false;
  String query = '';
  int counter = 0;
  bool called = false;
  Future dataResult = Future(() => false);
  Future categorisedStores = Future(() => false);

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

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
      marketProvider = Provider.of<StoreProvider>(context);

      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        if (_clientProvider.client?.address == null &&
            _addressProvider.address == null) {
          Config.bottomSheet(context);
        }
      });

      if (_addressProvider.address != null) {
        categorisedStores = _getStores();
      }

      dataResult = _getMarkets();
    }
  }

  _getMarkets() async {
    return await marketProvider.getStoreType();
  }

  _getStores() async {
    return await marketProvider.getStores(_addressProvider.address!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  onChange(String value) {
    query = value;
  }

  onClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isSearching = !isSearching;
    });
  }

  onTap() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return WillPopScope(
      onWillPop: () async => false,
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
            child: Container(
              width: 300,
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
                      Container(
                        width: screenSize(context).width * 0.3,
                        child: Text(
                          "${_addressProvider.address?.address ?? 'current Location'}",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.ubuntu(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Config.darkBlue),
                        ),
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
              iconSize: 30,
              color: Config.darkBlue,
              icon: Icon(CupertinoIcons.bars)),
          automaticallyImplyLeading: false,
          actions: [
            Stack(children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, NotificationScreen.id);
                  },
                  iconSize: 26,
                  color: Config.darkBlue,
                  icon: Icon(CupertinoIcons.bell_fill)),
              counter != 0
                  ? Positioned(
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
                            '$counter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ]),
          ],
        ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                child: Text(
                  "Ahlan, ${_clientProvider.client?.name ?? 'Visitor'} !",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )
                    .paddingOnly(top: 10, left: 15)
                    .align(alignment: Alignment.topLeft),
              ),
            ),
            _content(),
            _sections()
          ],
        ),
      ),
    );
  }

  Widget _content() {
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
                future: dataResult,
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
                  if (marketProvider.storesType.length == 0) {
                    marketProvider.getStoreType();
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
                    itemCount: marketProvider.storesType.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                          onTap: () {
                            marketProvider.setStoreType(
                                marketProvider.storesType[i].name);
                            Navigator.pushNamed(context, Store.id,
                                arguments: marketProvider.storesType[i].id);
                          },
                          child: StoreWidget(
                              title: "${marketProvider.storesType[i].name}",
                              imageUrl: marketProvider.storesType[i].image));
                    },
                  ).paddingOnly(left: 10);
                }),
          ),
        ],
      ),
    ));
  }

  Widget _sections() {
    return SliverToBoxAdapter(
        child: FutureBuilder(
            future: categorisedStores,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator()
                    .paddingOnly(top: 100)
                    .center();
              if (marketProvider.storesType.length == 0) {
                if (_addressProvider.address != null)
                  marketProvider.getStores(_addressProvider.address!);
                return Text("No data").paddingOnly(top: 100).center();
              } else
                return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: marketProvider.storesType.length,
                    itemBuilder: (context, index) {
                     
                      return marketProvider.storesType[index].stores.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${marketProvider.storesType[index].name}",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ).paddingOnly(bottom: 10, left: 15),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: marketProvider
                                                  .storesType[index]
                                                  .stores
                                                  .length >=
                                              3
                                          ? 3
                                          : marketProvider
                                              .storesType[index].stores.length,
                                      itemBuilder: (context, i) {
                                        return HomeCategory(
                                            store: marketProvider
                                                .storesType[index].stores[i]);
                                      }),
                                  if (marketProvider
                                          .storesType[index].stores.length >
                                      3)
                                    InkWell(
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
                                              "View all stores (${marketProvider.storesType[index].stores.length - 3})",
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
                              height: 50,
                              width: 0,
                            );
                    });
            }));
  }
}
