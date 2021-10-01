import 'package:daeem/models/market.dart' as model;
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/map_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/drawer.dart';
import 'package:daeem/widgets/market_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const id = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "John";
  late TextEditingController _controller;
  double value = 3.5;
  final ScrollController _scrollController = ScrollController();
  int itemCount = 5;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Future dataResult;
  MarketProvider marketProvider = MarketProvider();
  bool isSearching = false;
  String query = '';
  @override
  void initState() {
    _controller = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    marketProvider = Provider.of<MarketProvider>(context, listen: false);

    dataResult = _getMarkets();
    _scrollController.addListener(_scrollListener);
    super.didChangeDependencies();
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
          setState(() {});
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
                Navigator.pushNamed(context,MapScreen.id);
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
                  onPressed: () {},
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
                      ///Todo:Update the user
                      Text(
                        "Welcome, $userName!",
                        style: GoogleFonts.ubuntu(
                            fontSize: 26,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff4A4B4D)),
                      ).paddingAll(15).align(alignment: Alignment.topLeft),
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
                      ).paddingOnly(bottom: 10),
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
              return CircularProgressIndicator(
                color: Config.color_1,
              ).paddingOnly(top: 20).center();
            }
            return ListView.builder(
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
                });
          }),
    );
  }

  Widget _content() {
    return SliverToBoxAdapter(
      child: FutureBuilder(
          future: dataResult,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: Config.color_1,
              ).paddingOnly(top: 20).center();
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
