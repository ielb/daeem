import 'package:daeem/models/market.dart' as model;
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/loading/market_shimmer.dart';
import 'package:daeem/screens/map_screen.dart';
import 'package:daeem/screens/store_screen.dart';
import 'package:daeem/screens/test.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/drawer.dart';
import 'package:daeem/widgets/market_widget.dart';
import 'package:daeem/widgets/store_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool isSearching = false;
  String query = '';
  @override
  void initState() {
    _scrollController = ScrollController();
    _controller = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    marketProvider = Provider.of<MarketProvider>(context, listen: false);
    _clientProvider = Provider.of<ClientProvider>(context, listen: false);
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
    print(value);
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
                Navigator.pushNamed(context, MapScreen.id);
              },
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
                        "Current Location",
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
            leading: IconButton(
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
                iconSize: 30,
                color: Config.darkBlue,
                icon: Icon(CupertinoIcons.bars)),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Test()));
                  },
                  iconSize: 26,
                  color: Config.darkBlue,
                  icon: Icon(CupertinoIcons.bell_fill)),
            ],
          ),
          body: CustomScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                elevation: 0,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    height: 300,
                    child: Column(children: [
                      //Todo:Update the user
                      //?sss
                      Text(
                        "Welcome, ${_clientProvider.client?.name ?? ''}",
                        style: GoogleFonts.ubuntu(
                            fontSize: 26,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff4A4B4D)),
                      ).paddingAll(15).align(alignment: Alignment.topLeft),
                      SearchInput(
                        _controller,
                        "Search for a store",
                        screenSize(context).width * .91,
                        CupertinoIcons.search,
                        onChanged: onChange,
                        onClose: onClose,
                        onTap: onTap,
                        searching: isSearching,
                        isHavingShadow: true,
                      ).paddingOnly(bottom: 10),
                    ]),
                  ),
                ),
              ),
              _title(),
              isSearching ? _searchedContent() : _content()
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchedContent() {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<model.Market>>(
          future: marketProvider.getSearchedMarkets(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: 5,
                itemExtent: 250,
                itemBuilder: (context, index) {
                  return MarketLoading()
                      .paddingOnly(left: 20, right: 20, bottom: 20);
                },
              );
            }
            return snapshot.data?.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemExtent: 250,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return MarketWidget(
                              snapshot.data![index].name!,
                              snapshot.data![index].cover,
                              snapshot.data![index].address!,
                              snapshot.data![index].hours,
                              5)
                          .paddingOnly(left: 20, right: 20, bottom: 20);
                    })
                : Text("We didn't find what are you searching about")
                    .paddingAll(50)
                    .center();
          }),
    );
  }

  Widget _title() {
    return SliverToBoxAdapter(
        child: Text(
      "Category",
      style: GoogleFonts.ubuntu(
          fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
    ).paddingAll(20));
  }

  Widget _content() {
    return SliverToBoxAdapter(
        child: Container(
      height: screenSize(context).height * .6,
      child: GridView(
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 25,
        ),
        children: [
          InkWell(
              onTap: () {
                marketProvider.setStoreType("Grocery");
                Navigator.pushNamed(context, Store.id);
              },
              child: StoreWidget(
                title: "Grocery",
                imageUrl: "assets/grocery.png",
              )),
          InkWell(
              onTap: () {                
                marketProvider.setStoreType("Pharmacy");
                Navigator.pushNamed(context, Store.id);
              },
              child: StoreWidget(
                title: "Pharmacy",
                imageUrl: "assets/pharmacy_1.png",
              )),
        ],
      ),
    ));
  }
}
