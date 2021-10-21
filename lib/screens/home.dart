import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
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
  late Future dataResult;
  late MarketProvider marketProvider;
  late ClientProvider _clientProvider;
  late AddressProvider _addressProvider;
  bool isSearching = false;
  String query = '';
  @override
  void initState() {
    _scrollController = ScrollController();
    _controller = TextEditingController();
    WidgetsBinding.instance?.scheduleFrameCallback((timeStamp) {
      if (Provider.of<AddressProvider>(context, listen: false).address ==
          null) {
        Config.bottomSheet(context);
      }
    });
    super.initState();
  }

  int counter = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    marketProvider = Provider.of<MarketProvider>(context, listen: false);
    _clientProvider = Provider.of<ClientProvider>(context, listen: false);
    _addressProvider = Provider.of<AddressProvider>(context, listen: false);
    dataResult = _getMarkets();
    _scrollController.addListener(_scrollListener);
  }

  _getMarkets() async {
    return await marketProvider.getMarkets();
  }

  @override
  void dispose() {
    _controller.dispose();
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
    print(_addressProvider.address?.address);
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
                Navigator.pushNamed(context, MapScreen.id);
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
                        Text(
                          "${_addressProvider.address?.address ?? 'current Location'}",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.ubuntu(
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                              color: Config.darkBlue),
                        ),
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: Config.color_2,
                          size: 20,
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
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              itemExtent: 100,
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, i) {
                return InkWell(
                    onTap: () {
                      marketProvider.setStoreType("Grocery");
                      Navigator.pushNamed(context, Store.id);
                    },
                    child: StoreWidget(
                      title: "Grocery",
                      imageUrl: "assets/grocery.png",
                    ));
              },
            ),
          ),
        ],
      ),
    ));
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
                child: Align(alignment: Alignment.center,child: Text("View all stores (${length-3})",
                softWrap: true,
                overflow: TextOverflow.ellipsis,style: GoogleFonts.ubuntu(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),)),
          ),
        ).align(
          alignment: Alignment.center,
        )
      ],
    ));
  }

 
}
