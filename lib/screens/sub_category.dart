import 'dart:ui';

import 'package:daeem/models/market.dart';
import 'package:daeem/models/sub_category.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/screens/products_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/market_category.dart';
import 'package:flutter/cupertino.dart';

class Category extends StatefulWidget {
  static const id = "category";

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late TextEditingController _searchController;
  bool _isClosed = false;
  Market market = Market();
  CategoryProvider _categoryProvider = CategoryProvider();
  late Future dataResult;
  bool isSearching = false;
  bool _called = false;
  String query = '';
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

      dataResult = _getSubCategories(id);
      setState(() {
        _called = true;
      });
    }
    super.didChangeDependencies();
  }

  _getSubCategories(int id) {
    return _categoryProvider.getSubCategories(id);
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
    _categoryProvider.clearSubSearched();
    _searchController.clear();
  }

  onTap() {
    setState(() {
      isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          ///App bar
          SliverPersistentHeader(
            delegate: CustomSliverAppBarDelegate(market, 200),
            pinned: true,
          ),

          ///Closed sign
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
                                style:
                                    GoogleFonts.ubuntu(color: Config.color_1))
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
            "Search for supermarket",
            screenSize(context).width * .81,
            CupertinoIcons.search,
            onChanged: onChange,
            onClose: onClose,
            onTap: onTap,
            searching: isSearching,
          ).paddingOnly(left: 20, right: 20, top: _isClosed ? 10 : 80)),
          isSearching ? _searchedContent() : _content()
        ],
      ),
    );
  }

  ///Content list
  Widget _searchedContent() {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<SubCategory>>(
          future: _categoryProvider.searchForSubCategories(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: Config.color_1,
              ).paddingOnly(top: 20).center();
            }
            return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemExtent: 200,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return CategoryWidget(snapshot.data![index].name!,
                          snapshot.data![index].image!)
                      .paddingOnly(left: 20, right: 20, bottom: 20);
                });
          }),
    );
  }

  ///Content list
  Widget _content() => SliverToBoxAdapter(
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
                itemCount: _categoryProvider.subCategories.length,
                itemExtent: 190,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, ProductsPage.id,
                        arguments: [
                          market,
                          _categoryProvider.subCategories[index].id
                        ]),
                    child: CategoryWidget(
                            _categoryProvider.subCategories[index].name!,
                            _categoryProvider.subCategories[index].image!)
                        .paddingOnly(left: 20, right: 20, bottom: 20),
                  );
                },
              );
            }),
      );
}
