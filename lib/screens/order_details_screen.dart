// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:daeem/models/OrderProduct.dart';
import 'package:daeem/models/order.dart';
import 'package:daeem/models/status.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timelines/timelines.dart';

class OrderDetails extends StatefulWidget {
  static const String id = 'order_detail';
  final Order order;
  OrderDetails({required this.order});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late ClientProvider client;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      client = Provider.of<ClientProvider>(context, listen: false);
    });
    super.initState();
  }

  _refund() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Refund',
              style: GoogleFonts.ubuntu(
                fontSize: 19,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              )),
          content: Text('Are you sure you want to refund this order?',
              style: GoogleFonts.ubuntu(
                fontSize: 18,
                color: Colors.black,
              )),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    color: Config.color_2,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm',
                  style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    color: Colors.red,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                client.refundOrder(widget.order.id, "nothing").then((value) {
                  if (value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "My order details",
            style: GoogleFonts.ubuntu(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Ionicons.chevron_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SizedBox(
            width: screenSize(context).width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(10),
                width: screenSize(context).width * .9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          offset: Offset(0, 10),
                          blurRadius: 20)
                    ]),
                child: Column(children: <Widget>[
                  Text(
                    "Order id #${widget.order.code}",
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      .paddingOnly(left: 10, top: 10)
                      .align(alignment: Alignment.centerLeft),
                  _DeliveryProcesses(
                    processes: widget.order.status_history,
                  ).center(),
                  Text(
                    "Order details",
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      .paddingOnly(left: 10)
                      .align(alignment: Alignment.centerLeft),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemExtent: 110,
                    itemBuilder: (context, index) {
                      return ProductWidget(
                        product: widget.order.products[index],
                      );
                    },
                    itemCount: widget.order.products.length,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Total Amount",
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ).align(alignment: Alignment.centerLeft),
                      Text(
                        "${widget.order.order_price}",
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ).align(alignment: Alignment.centerRight),
                    ],
                  )
                      .paddingOnly(left: 10)
                      .align(alignment: Alignment.centerLeft),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Delivery Fee",
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ).align(alignment: Alignment.centerLeft),
                      Text(
                        "${widget.order.delivery_price}",
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ).align(alignment: Alignment.centerRight),
                    ],
                  )
                      .paddingOnly(left: 10, bottom: 15)
                      .align(alignment: Alignment.centerLeft),
                  if (widget.order.current_status.id == 5)
                    Container(
                        height: 50,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .6,
                          child: TextButton(
                            onPressed: () {
                              _refund();
                            },
                            child: Text(
                              "Refund",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )),
                ]),
              ),
            ).center()));
  }
}

class ProductWidget extends StatelessWidget {
  const ProductWidget({required this.product});
  final OrderdProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  filterQuality: FilterQuality.high,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                              value: downloadProgress.progress)
                          .center(),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/placeholder.png",
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                  ),
                  height: 80,
                  width: 80,
                ),
                borderRadius: BorderRadius.circular(15),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 140,
                    child: Text("${product.name}",
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ubuntu(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500))
                        .paddingOnly(left: 5),
                  ),
                  Text(product.variant != null ? "${product.variant}" : '',
                          style: GoogleFonts.ubuntu(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500))
                      .paddingOnly(left: 4),
                ],
              ),
              Spacer(),
              Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${product.price}DH",
                      style: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  Text("x${product.quantity}",
                      style: GoogleFonts.ubuntu(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))
                ],
              )),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key? key, required this.processes})
      : super(key: key);

  final List<Status> processes;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          processes[index].name,
                          style: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${DateFormat("EEE, d MMM yyyy").format(DateTime.parse(processes[index].time!))}",
                          style: GoogleFonts.ubuntu(
                              fontSize: 16.0, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (processes[index].id == 6 || processes[index].id == 7)
                return DotIndicator(
                  color: Colors.red,
                  size: 25,
                  child: Icon(
                    Ionicons.close,
                    color: Colors.white,
                    size: 16.0,
                  ),
                );
              else if (processes[index].id == 10)
                return DotIndicator(
                  color: Colors.blue,
                   size: 25,
                  child: Icon(
                    Ionicons.cash_outline,
                    color: Colors.white,
                    size: 16.0,
                  ),
                );
              else
                return DotIndicator(
                  color: Color(0xff66c97f),
                   size: 25,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16.0,
                  ),
                );
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              thickness: 3,
              color: processes[index].id == 6 || processes[index].id == 7
                  ? Colors.red
                  :  processes[index].id == 10 ? Colors.blue : Color(0xff66c97f),
            ),
          ),
        ),
      ),
    );
  }
}
