import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  List<String> size = [
    "S",
    "M",
    "L",
    "XL",
  ];

  int _selectedSize = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height * 0.6,
          elevation: 0,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          snap: true,
          floating: true,
          stretch: true,
          backgroundColor: Colors.grey.shade50,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [
              StretchMode.zoomBackground,
            ],
            background: CachedNetworkImage(
                imageUrl:
                    "https://images.unsplash.com/photo-1601275868399-45bec4f4cd9d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=735&q=80",
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress).center(),
                errorWidget: (context, url, error) => Image.asset(
                      "assets/placeholder.png",
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    )),
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(45),
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
                  child: Center(
                      child: Container(
                    width: 50,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
                ),
              )),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
              height: MediaQuery.of(context).size.height * 0.55,
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
                            Text(
                              "Appel",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Fruit",
                              style: TextStyle(
                                color: Config.color_2,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "8.00 MAD",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Take a break from jeans with the parker long straight pant. These lightweight, pleat front pants feature a flattering high waist and loose, straight legs.",
                      style: TextStyle(
                        height: 1.5,
                        color: Colors.grey.shade800,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Size',
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: size.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSize = index;
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
                                  size[index],
                                  style: TextStyle(
                                      color: _selectedSize == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      height: 50,
                      elevation: 0,
                      splashColor: Colors.yellow[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Config.color_2,
                      child: Center(
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ])),
      ]),
    );
  }
}
