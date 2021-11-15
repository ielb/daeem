import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/models/item.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/screens/cart_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';

class ProductDetails extends StatefulWidget {
  static const id = "product_details";
  ProductDetails({required this.product});
  final Product product;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool called = false;
  bool isAdded = false;
  late CartProvider cart;
  int _selectedSize = 0;
  Item? pageProduct;
  @override
  void didChangeDependencies() {
    if (!called) {
      cart = Provider.of<CartProvider>(context);
      // widget.product.price = widget.product.variants[0].price;

      setState(() {
        called = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  addToCart(Product product, BuildContext context) {
    Item item = Item(product: product, quantity: 1);
    var result = cart.addToBasket(item);
    if (result) {
      setState(() {
        pageProduct = item;
        isAdded = true;
      });
    }
    setState(() {});
  }

  removeFromCart(Product product, BuildContext context) {
    var cart = Provider.of<CartProvider>(context, listen: false);
    Item item = Item(product: product);
    cart.removeFromBasket(item);
    setState(() {});
  }

  int? getItemCount(int id, BuildContext context) {
    Item data = cart.basket.singleWhere((element) => id == element.product.id,
        orElse: () => Item(product: Product()));
    return data.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Ionicons.close_outline),
              color: Colors.black,
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, CartPage.id);
                },
                child: Stack(children: <Widget>[
                  Icon(Ionicons.bag_handle, size: 26, color: Config.black)
                      .paddingOnly(top: 10, right: 10),
                  cart.basket.length != 0
                      ? Positioned(
                          right: 2,
                          top: 5,
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
                                '${cart.basket.length}',
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
              ),
            ],
            snap: true,
            floating: true,
            stretch: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [
                StretchMode.zoomBackground,
              ],
              background: CachedNetworkImage(
                  imageUrl: widget.product.image!,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                              value: downloadProgress.progress)
                          .center(),
                  errorWidget: (context, url, error) => Image.asset(
                        "assets/placeholder.png",
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      )),
            ),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Transform.translate(
                  offset: Offset(0, 1),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                )),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenSize(context).width * .7,
                                child: Text(
                                  widget.product.name!,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "${widget.product.price} MAD",
                                style: TextStyle(
                                    color: Config.color_1,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${widget.product.description}",
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.grey.shade800,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (widget.product.hasVariant != 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Size',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 60,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.product.variants.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedSize = index;
                                        widget.product.price = widget
                                            .product.variants[index].price;
                                        widget.product.currentVariant =
                                            widget.product.variants[index];
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          color: _selectedSize == index
                                              ? Config.color_2
                                              : Colors.grey.shade200,
                                          shape: BoxShape.circle),
                                      width: 40,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          widget.product.variants[index].option
                                                  ?.toLowerCase() ??
                                              "",
                                          style: TextStyle(
                                              color: _selectedSize == index
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ))
          ])),
        ]),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          height: 60,
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: getItemCount(widget.product.id!, context) == 0
              ? MaterialButton(
                  onPressed: () {
                    addToCart(widget.product, context);
                  },
                  height: 50,
                  elevation: 0,
                  splashColor: Config.color_2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Config.color_2,
                  child: Center(
                    child: Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Config.color_2),
                      color: Config.color_2.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          removeFromCart(widget.product, context);
                        },
                        child: Icon(
                          Ionicons.remove_outline,
                          color: Config.color_2,
                          size: 28,
                        ),
                      ),
                      Spacer(),
                      RichText(
                          text:
                              //!count the product
                              TextSpan(
                                  text:
                                      "${getItemCount(widget.product.id!, context)} ",
                                  style: GoogleFonts.ubuntu(
                                      color: Config.color_1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  children: [
                            //!variant
                            TextSpan(
                              text: "PCS",
                              style: GoogleFonts.ubuntu(
                                  color: Config.color_1, fontSize: 14),
                            )
                          ])),
                      Spacer(),
                      InkWell(
                        child: Icon(
                          Ionicons.add_outline,
                          color: Config.color_2,
                          size: 28,
                        ),
                        onTap: () {
                          addToCart(widget.product, context);
                        },
                      ),
                    ],
                  ),
                ),
        ));
  }
}
