import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/models/item.dart';
import 'package:daeem/models/market.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/screens/loading/product_shimmer.dart';
import 'package:daeem/screens/product_details.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/product_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';

class ProductsPage extends StatefulWidget {
  static const id = "products";

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late TextEditingController _searchController;
  bool _isClosed = false;
  bool isSearching = false;
  bool _called = false;
  String query = '';
  Store market = Store();
  Future<bool> dataResult = Future(() => false);
  late CategoryProvider _categoryProvider;
  late CartProvider cart;
  int itemCount = 1;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    if (!_called) {
      cart = Provider.of<CartProvider>(context);
      _categoryProvider = Provider.of<CategoryProvider>(context);
      var list = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      market = list[0] as Store;
      int id = list[1] as int;
      dataResult = _getProducts(id);
      setState(() {
        _called = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _called = false;
    query = '';
    _searchController.clear();
    super.dispose();
  }

  _getProducts(int id) {
    if (_categoryProvider.products.isEmpty)
      return _categoryProvider.getProducts(id);
    return Future(() => false);
  }

  onChange(String value) {
    query = value;
  }

  onClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isSearching = false;
    });
    _categoryProvider..clearSearchedProducts();
    _searchController.clear();
  }

  onTap() {
    setState(() {
      isSearching = true;
    });
  }

  addToCart(Product product, BuildContext context) {
    Item item = Item(product: product, quantity: 1);
    cart.addToBasket(item);
    setState(() {});
  }

  removeFromCart(Product product, BuildContext context) {
    Item item = Item(product: product);
    cart.removeFromBasket(item);
    setState(() {});
  }

  Future<bool> _backPressed() async {
    _categoryProvider.closeProducts();
    Navigator.of(context).pop(context);
    return true;
  }

  _productPressed(Product product) async {
    Navigator.of(context).pushNamed(ProductDetails.id, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: StickyOrder(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  //?App bar
                  SliverPersistentHeader(
                    delegate:
                        CustomSliverAppBarDelegate(market, 200, isSub: true),
                    pinned: true,
                  ),
                  //*Closed sign
                  if (_isClosed)
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
                                        text:
                                            "This store is closed at the moment.",
                                        style: GoogleFonts.ubuntu(
                                            color: Colors.black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w400),
                                        children: [
                                      TextSpan(
                                          text:
                                              "Looking for something similar?",
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
                  //?SearchField
                  SliverToBoxAdapter(
                      child: SearchInput(
                    _searchController,
                    "Search for product",
                    screenSize(context).width * .81,
                    CupertinoIcons.search,
                    onChanged: onChange,
                    onClose: onClose,
                    onTap: onTap,
                    searching: isSearching,
                    isHavingShadow: true,
                  ).paddingOnly(left: 20, right: 20, top: _isClosed ? 10 : 80)),
                  //*content
                  isSearching ? _searchedContent(context) : _content(context),
                  SliverToBoxAdapter(
                      child: SizedBox(
                    height: 50,
                  )),
                ],
              ),
              mcontext: context)),
    );
  }

  Widget _searchedContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<Product>>(
          future: _categoryProvider.searchForProduct(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: 5,
                itemExtent: 80,
                itemBuilder: (context, index) {
                  return ProductLoading()
                      .paddingOnly(left: 20, right: 20, bottom: 20);
                },
              );
            }else
            return snapshot.data?.length == 0
                ? Text("This product out of stock").paddingAll(50).center()
                : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemExtent: 80,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return snapshot.hasData
                          ? ProductWidget(
                              product: snapshot.data![index], onTap: (){
                                 _productPressed(snapshot.data![index]);
                              } )
                          : Text("This product out of stock")
                              .paddingAll(50)
                              .center();
                    });
          }),
    );
  }

  Widget _content(BuildContext context) => SliverToBoxAdapter(
        child: FutureBuilder(
            future: dataResult,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 5,
                  itemExtent: 80,
                  itemBuilder: (context, index) {
                    return ProductLoading()
                        .paddingOnly(left: 20, right: 20, bottom: 20);
                  },
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _categoryProvider.products.length,
                  itemExtent: 80,
                  itemBuilder: (context, index) {
                    return ProductWidget(
                        product: _categoryProvider.products[index],
                        onTap: () {
                          _productPressed(_categoryProvider.products[index]);
                        });
                  }).paddingOnly(bottom: 50);
            }),
      );

 
}
