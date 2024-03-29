import 'package:daeem/models/market.dart';
import 'package:daeem/models/market_category.dart';
import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/screens/checkout_screen.dart';
import 'package:daeem/screens/loading/category_shimmer.dart';
import 'package:daeem/screens/sub_category.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/market_category.dart';
import 'package:flutter/cupertino.dart';

class MarketPage extends StatefulWidget {
  static const id = "market";

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  late TextEditingController _searchController;
  bool _isClosed = false;
  bool isSearching = false;
  bool _called = false;
  Store market = Store();
  String query = '';
  late CategoryProvider _categoryProvider;
  late CartProvider cart;
  late AuthProvider auth;
  late Future dataResult;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _backPress();
    _searchController.dispose();
    _called = false;
    _isClosed = false;
    isSearching = false;

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_called) {
      market = ModalRoute.of(context)!.settings.arguments as Store;
      cart = Provider.of<CartProvider>(context);
      auth = Provider.of<AuthProvider>(context);
      _categoryProvider = Provider.of<CategoryProvider>(context);
      dataResult = _getSubCategories(market.id!);
      setState(() {
        _called = true;
      });
    }
    super.didChangeDependencies();
  }

  _getSubCategories(int id) {
    return _categoryProvider.getCategories(id);
  }

  onChange(String value) {
    query = value;
    print(value);
  }

  onClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isSearching = false;
    });
    _categoryProvider.clearSearched();
    _searchController.clear();
  }

  onTap() {
    setState(() {
      isSearching = true;
    });
  }

  Future<bool> _backPress() async {
    _categoryProvider.closeSub();
    _categoryProvider.close();
    if (cart.isCartEmpty()) {
      _categoryProvider.closeProducts();
    } else {
      if (auth.isAuth()) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  height: 400,
                  width: 400,
                  child: Column(
                    children: [
                      Image.asset("assets/cart.png").paddingAll(25),
                      Text("Your cart will be deleted",
                          style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      Text("Please complete your order",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey))
                          .paddingAll(20),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              cart.clearCart();
                              Navigator.of(context)
                                  .pushReplacementNamed(Home.id);
                            },
                            child: Text(
                              "Cancel anyway",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 14, color: Colors.red.shade500),
                            ),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, CheckoutPage.id);
                            },
                            child: Text(
                              "Go to checkout",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 14, color: Config.color_2),
                            ),
                          ),
                        ],
                      ).paddingOnly(left: 20, right: 20, bottom: 20)
                    ],
                  ),
                ));
          },
        );
      } else {
        cart.clearCart();
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backPress,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StickyOrder(
          mcontext: context,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              ///App bar
              SliverPersistentHeader(
                delegate:
                    CustomSliverAppBarDelegate(market, 200, isMarket: true),
                pinned: true,
              ),

              ///Closed sign
              if (!market.status!)
                SliverToBoxAdapter(
                    child: Container(
                  height: 55,
                  width: 300,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Config.closed,
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: "This store is closed at the moment.",
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w400),
                                    children: [
                                  TextSpan(
                                      text: "Looking for something similar?",
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.black,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600))
                                ])),
                            Text("Explore stores near you",
                                    style: GoogleFonts.ubuntu(
                                        color: Config.color_1))
                                .align(alignment: Alignment.bottomLeft)
                                .paddingOnly(right: 105)
                          ])
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xffFFF3DA),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 2,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        )
                      ]),
                )),

              ///SearchField
              SliverToBoxAdapter(
                  child: SearchInput(
                _searchController,
                "Search for category",
                screenSize(context).width * .81,
                CupertinoIcons.search,
                onChanged: onChange,
                onClose: onClose,
                onTap: onTap,
                searching: isSearching,
                isHavingShadow: true,
              ).paddingOnly(left: 20, right: 20, top: _isClosed ? 10 : 80)),
              isSearching ? _searchedContent() : _content()
            ],
          ),
        ),
      ),
    );
  }

  ///Content list
  Widget _searchedContent() {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<MarketCategory>>(
          future: _categoryProvider.searchForCategories(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: 5,
                itemExtent: 250,
                itemBuilder: (context, index) {
                  return CategoryLoading()
                      .paddingOnly(left: 20, right: 20, bottom: 20);
                },
              );
            }

            if (!market.status!) {
              return Column(
                children: [
                  Image.asset(
                    "assets/closed_stores.gif",
                    height: screenSize(context).height * .4,
                  ),
                  Text("This store is currently closed",
                      style: GoogleFonts.ubuntu(
                          fontSize: 20, fontWeight: FontWeight.w500))
                ],
              );
            } else
              return snapshot.data?.length != 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemExtent: 200,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return CategoryWidget(snapshot.data![index].name!,
                                snapshot.data![index].image!)
                            .paddingOnly(left: 20, right: 20, bottom: 20);
                      })
                  : Text("We didn't find what are you searching about")
                      .paddingAll(50)
                      .center();
          }),
    );
  }

  Widget _content() => SliverToBoxAdapter(
        child: FutureBuilder(
            future: dataResult,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 5,
                  itemExtent: 150,
                  itemBuilder: (context, index) {
                    return CategoryLoading()
                        .paddingOnly(left: 20, right: 20, bottom: 20);
                  },
                );
              }
              if (_categoryProvider.categories.length == 0) {
                _categoryProvider.getCategories(market.id!);
                return Column(
                  children: [
                    Image.asset(
                      "assets/closed_stores.gif",
                      height: screenSize(context).height * .4,
                    ),
                    Text("This store is currently closed",
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, fontWeight: FontWeight.w500))
                  ],
                );
              }
              if (!market.status!) {
                return Column(
                  children: [
                    Image.asset(
                      "assets/closed_stores.gif",
                      height: screenSize(context).height * .4,
                    ),
                    Text("This store is currently closed",
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, fontWeight: FontWeight.w500))
                  ],
                );
              } else
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _categoryProvider.categories.length,
                  itemExtent: 150,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Category.id,
                          arguments: [
                            market,
                            _categoryProvider.categories[index].id
                          ]),
                      child: CategoryWidget(
                              _categoryProvider.categories[index].name!,
                              _categoryProvider.categories[index].image!)
                          .paddingOnly(left: 20, right: 20, bottom: 30),
                    );
                  },
                );
            }),
      );
}
