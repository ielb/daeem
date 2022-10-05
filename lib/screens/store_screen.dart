// ignore_for_file: non_constant_identifier_names

import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:daeem/models/market.dart' as model;
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/loading/market_shimmer.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/market_widget.dart';

class Store extends StatefulWidget {
  static const id = "Store";

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  String userName = "John";
  late TextEditingController _controller;
  double value = 3.5;
  late ScrollController _scrollController;
  int itemCount = 5;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Future dataResult;
  late StoreProvider marketProvider;

  late AddressProvider _addressProvider;
  bool isSearching = false;
  String query = '';
  late String store_id;
  bool called = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _controller = TextEditingController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!called) {
      store_id = ModalRoute.of(context)!.settings.arguments as String;
      marketProvider = Provider.of<StoreProvider>(context);
      _addressProvider = Provider.of<AddressProvider>(context);

      dataResult = _getMarkets();
      setState(() {
        called = !called;
      });
    }
    super.didChangeDependencies();
  }

  _getMarkets() async {
    return await marketProvider.getMarkets(_addressProvider.address!, store_id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (!isSearching) if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {}
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
      onWillPop: () async => true,
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            marketProvider.storeType ?? "Supermarches",
            style: GoogleFonts.ubuntu(
                fontSize: 24, fontWeight: FontWeight.w500, color: Config.black),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 30,
              color: Config.darkBlue,
              icon: Icon(CupertinoIcons.back)),
          automaticallyImplyLeading: false,
        ),
        body: CustomScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 80,
                child: Column(children: [
                  SearchInput(
                    _controller,
                    "Search for supermarket",
                    screenSize(context).width * .91,
                    CupertinoIcons.search,
                    onChanged: onChange,
                    onClose: onClose,
                    onTap: onTap,
                    searching: isSearching,
                    isHavingShadow: true,
                  ).paddingOnly(bottom: 10, top: 5),
                ]),
              ),
            ),
            isSearching ? _searchedContent() : _content()
          ],
        ),
      ),
    );
  }

  Widget _searchedContent() {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<model.Store>>(
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
                          store: snapshot.data![index],
                          onRate: (rate) {
                            marketProvider.rate(
                                snapshot.data![index].id!,
                                int.parse(Provider.of<ClientProvider>(context)
                                    .client!
                                    .id!),
                                rate);
                          }).paddingOnly(left: 20, right: 20, bottom: 20);
                    })
                : Text("We didn't find what are you searching about")
                    .paddingAll(50)
                    .center();
          }),
    );
  }

  Widget _content() {
    return SliverToBoxAdapter(
      child: FutureBuilder(
          future: dataResult,
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
            if (marketProvider.markets.isEmpty) {
              return Column(children: [
                Config.empty,
                SizedBox(height: screenSize(context).height * 0.1),
                Text("No stores right now",
                    style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: screenSize(context).height * 0.1),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Home.id);
                  },
                  child: Text(
                    "Back home",
                  ),
                  style: ElevatedButton.styleFrom(
                      textStyle: GoogleFonts.ubuntu(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                      shadowColor: Config.color_2,
                      backgroundColor: Config.color_2,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15),
                      ),
                      fixedSize: Size(270, 50)),
                )
              ]);
            }
            return ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: marketProvider.markets.length,
              itemExtent: 250,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    marketProvider
                        .setCurrentMarket(marketProvider.markets[index]);
                    Navigator.pushNamed(context, MarketPage.id,
                        arguments: marketProvider.markets[index]);
                  },
                  child: MarketWidget(
                      store: marketProvider.markets[index],
                      onRate: (rate) {
                        marketProvider.rate(
                            marketProvider.markets[index].id!,
                            int.parse(Provider.of<ClientProvider>(context,
                                    listen: false)
                                .client!
                                .id!),
                            rate);
                      }).paddingOnly(left: 20, right: 20, bottom: 20),
                );
              },
            );
          }),
    );
  }
}
