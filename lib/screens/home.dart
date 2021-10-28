import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/client/add_address.dart';
import 'package:daeem/screens/loading/category_shimmer.dart';
import 'package:daeem/screens/map_screen.dart';
import 'package:daeem/screens/notification_screen.dart';
import 'package:daeem/screens/store_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/drawer.dart';
import 'package:daeem/widgets/home_category_widget.dart';
import 'package:daeem/widgets/store_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  static const id = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "John";
  late TextEditingController _controller;
  double value = 3.5;
  late ScrollController _scrollController;
  int itemCount = 5;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late MarketProvider marketProvider;
  late ClientProvider _clientProvider;
  late AddressProvider _addressProvider;
  bool isSearching = false;
  String query = '';
  int counter = 0;
  bool called = false;
  Future dataResult = Future(() => false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!called) {
      _scrollController = ScrollController();
      _controller = TextEditingController();
      marketProvider = Provider.of<MarketProvider>(context);
      _clientProvider = Provider.of<ClientProvider>(context);
      _addressProvider = Provider.of<AddressProvider>(context);
      _scrollController.addListener(_scrollListener);
      if (_clientProvider.client?.address == null ||
          _addressProvider.address == null) {
        Config.bottomSheet(context);
      } else {
        dataResult = _getMarkets();
        setState(() {
          called = !called;
        });
      }
    }
  }

  _getMarkets() async {
    var result = await marketProvider.getStoreType();
    await marketProvider.getTypedStores(_clientProvider.client!);
    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (!isSearching) if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _getMarkets();
      });
    }
  }

  onChange(String value) {
    query = value;
  }

  onClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isSearching = !isSearching;
    });
    _controller.clear();
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
      child: RefreshIndicator(
        displacement: 50,
        color: Config.color_1,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          marketProvider.getMarkets();
        },
        child: Scaffold(
          key: _key,
          drawer: CustomDrawer(),
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: GestureDetector(
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
                          width: screenSize(context).width * 0.5,
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
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  child: Text(
                    "Ahlan, ${_clientProvider.client?.name ?? 'Visitor'} !",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.ubuntu(
                        fontSize: 24,
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
                        return typeLoader().paddingOnly(left: 10, right: 10);
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
                        return typeLoader().paddingOnly(left: 15, right: 15);
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
                                marketProvider.storesType[i].name ?? 'Grocery');
                            Navigator.pushNamed(context, Store.id);
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

  Widget typeLoader() {
    return Column(
      children: [
        Shimmer.fromColors(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15)),
                ),
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade50)
            .paddingOnly(bottom: 10),
        Shimmer.fromColors(
            child: Container(
              height: 10,
              width: 70,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15)),
            ),
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50)
      ],
    );
  }

  int length = 5;
  Widget _sections() {
    return SliverToBoxAdapter(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Supermarket",
          style: GoogleFonts.ubuntu(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
        ).paddingOnly(bottom: 10, left: 15),
        Container(
            child: Column(
          children: List.generate(
              length >= 3 ? 3 : length, (index) => HomeCategory()),
        )),
        InkWell(
          child: Container(
            height: 40,
            width: screenSize(context).width * .75,
            decoration: BoxDecoration(
                color: Config.color_2, borderRadius: BorderRadius.circular(15)),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  "View all stores (${length - 3})",
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
    ));
  }
}
