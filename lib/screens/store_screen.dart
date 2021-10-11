import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:daeem/models/market.dart' as model;
import 'package:daeem/provider/client_provider.dart';
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
  late MarketProvider marketProvider;
  // ignore: unused_field
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              marketProvider.storeType ?? "Supermarches",
              style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Config.black),
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
                      ).paddingOnly(bottom: 10, top: 40),
                    ]),
                  ),
                ),
              ),
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
            return ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: marketProvider.markets.length,
              itemExtent: 250,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, MarketPage.id,
                        arguments: marketProvider.markets[index]);
                  },
                  child: MarketWidget(
                    marketProvider.markets[index].name!,
                    marketProvider.markets[index].cover,
                    marketProvider.markets[index].address!,
                    marketProvider.markets[index].hours,
                    5,
                  ).paddingOnly(left: 20, right: 20, bottom: 20),
                );
              },
            );
          }),
    );
  }
}
