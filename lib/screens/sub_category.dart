import 'dart:ui';

import 'package:daeem/models/market.dart';
import 'package:daeem/models/sub_category.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/screens/loading/category_shimmer.dart';
import 'package:daeem/screens/products_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/market_category.dart';
import 'package:flutter/cupertino.dart';

class Category extends StatefulWidget {
  static const id = "category";
  Category({required this.category});
  final String category;


  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late TextEditingController _searchController;
  bool _isClosed = false;
  Store market = Store();
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
      market = list[0] as Store;
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
  Future<bool> _backPressed()async{
    _categoryProvider.closeSub();
    Navigator.of(context).pop(context);
    return true;
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
                "Search for sub category",
                screenSize(context).width * .81,
                CupertinoIcons.search,
                onChanged: onChange,
                onClose: onClose,
                onTap: onTap,
                searching: isSearching,
                isHavingShadow: true,
              ).paddingOnly(left: 20, right: 20, top: _isClosed ? 10 : 80)),
                SliverToBoxAdapter(
                  child:Text("{}",style: GoogleFonts.ubuntu(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold)).paddingOnly(left: 20,top: 20),),
              isSearching ? _searchedContent() : _content()
            ],

          ),
          mcontext: context,
        ),
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
               return  ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount:5,
              itemExtent: 150,
              itemBuilder: (context, index) {
                return CategoryLoading().paddingOnly(left: 20, right: 20, bottom: 20);
              },
            );
            }

            return snapshot.data?.length !=0   ? ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemExtent:150,
                itemCount:   snapshot.data?.length,
                itemBuilder: (context, index) {
                  return  CategoryWidget(snapshot.data![index].name!,
                          snapshot.data![index].image!)
                      .paddingOnly(left: 20, right: 20, bottom: 20) ;
                }): Text("We didn't find what are you searching about")
                              .paddingAll(50)
                              .center();
          }),
    );
  }

  ///Content list
  Widget _content() => SliverToBoxAdapter(
        child: FutureBuilder(
            future: dataResult,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                 return  ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount:5,
              itemExtent: 150,
              itemBuilder: (context, index) {
                return CategoryLoading().paddingOnly(left: 20, right: 20, bottom: 20);
              },
            );
              }
              if(_categoryProvider.subCategories.isEmpty){              
              return Column(children: [
                Config.empty,
                SizedBox(height: screenSize(context).height * 0.1),
                Text("There are no sub categories ",
                    style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: screenSize(context).height * 0.1),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Home.id);
                  },
                  child: Text("Continue shopping",
                     ),
                  style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.ubuntu(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                      shadowColor: Config.color_2,
                      primary: Config.color_2,
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
                itemCount: _categoryProvider.subCategories.length,
                itemExtent: 150,
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
