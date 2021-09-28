import 'package:daeem/models/item.dart';
import 'package:daeem/models/market.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

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
  Market market = Market();
  Future<bool> dataResult = Future(() => false);
  CategoryProvider _categoryProvider = CategoryProvider();
  int itemCount = 1;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    if (!_called) {
      _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      var list = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      market = list[0] as Market;
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
    return _categoryProvider.getProducts(id);
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
    _categoryProvider..clearSearchedProducts();
    _searchController.clear();
  }

  onTap() {
    setState(() {
      isSearching = true;
    });
  }

  addToCart(Product product, BuildContext context) {
    var cart = Provider.of<CartProvider>(context, listen: false);
    Item item = Item(product: product);
    cart.addToBasket(item);
  }

  removeFromCart(Product product, BuildContext context) {
    var cart = Provider.of<CartProvider>(context, listen: false);
    Item item = Item(product: product);
    cart.removeFromBasket(item);
  }

  int? getItemCount(int id, BuildContext context) {
    var cart = Provider.of<CartProvider>(context, listen: false);
       Item data = cart.basket.singleWhere((element) => id==element.product.id,orElse: () => Item(product: Product()));
    return data.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: StickyOrder(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  //?App bar
                  SliverPersistentHeader(
                    delegate: CustomSliverAppBarDelegate(market, 200),
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
                    "Search for supermarket",
                    screenSize(context).width * .81,
                    CupertinoIcons.search,
                    onChanged: onChange,
                    onClose: onClose,
                    onTap: onTap,
                    searching: isSearching,
                  ).paddingOnly(left: 20, right: 20, top: _isClosed ? 10 : 80)),
                  //*content
                  isSearching ? _searchedContent(context) : _content(context)
                ],
              ),
            ));
      },
      create: (BuildContext context) => CartProvider(),
    );
  }

  Widget _searchedContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<Product>>(
          future: _categoryProvider.searchForProduct(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: Config.color_1,
              ).paddingOnly(top: 20).center();
            }
            return snapshot.data?.length == 0
                ? Text("This product out of stock").paddingAll(50).center()
                : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemExtent: 80,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return snapshot.hasData
                          ? content(
                              product: snapshot.data![index], context: context)
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
                return CircularProgressIndicator(
                  color: Config.color_1,
                ).paddingOnly(top: 20).center();
              }
              return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _categoryProvider.products.length,
                  itemExtent: 80,
                  itemBuilder: (context, index) {
                    return content(
                        product: _categoryProvider.products[index],
                        context: context);
                  });
            }),
      );

  Widget content({required Product product, required BuildContext context}) {
    var cart = Provider.of<CartProvider>(context, listen: false);
    return ListTile(
        minVerticalPadding: 5,
        leading: Container(
          height: 60,
          width: 60,
          padding: EdgeInsets.all(5),
          child: Image.network(
            product.image ??
                "https://static.thenounproject.com/png/741653-200.png",
            width: 55,
            height: 55,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 2,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                )
              ]),
        ),
        title: Text(product.name!),
        subtitle: Text(product.price! + " MAD"),
        trailing: Container(
          width: 120,
          child: Row(
            children: [
              if (cart.basket.length != 0)
                Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          )
                        ]),
                    child: IconButton(
                      iconSize: 18,
                      onPressed: () => removeFromCart(product, context),
                      icon: Icon(CupertinoIcons.minus),
                      color: Colors.redAccent,
                    ).center())
              else
                SizedBox(
                  width: 35,
                ),
              SizedBox(
                width: 10,
              ),
              if (cart.basket.length != 0)
                getItemCount(product.id!, context) != null
                    ? Text("${getItemCount(product.id!, context)}x")
                    : Text("0")
              else
                SizedBox(
                  width: 10,
                ),
              SizedBox(
                width: 10,
              ),
              Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 2,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        )
                      ]),
                  child: IconButton(
                    onPressed: () => addToCart(product, context),
                    icon: Icon(CupertinoIcons.add),
                    color: Config.color_2,
                    iconSize: 18,
                  ).center())
            ],
          ),
        ));
  }
}
