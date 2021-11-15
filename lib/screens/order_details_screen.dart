// ignore_for_file: unused_element

import 'package:daeem/models/order.dart';
import 'package:daeem/models/status.dart';
import 'package:daeem/services/services.dart';
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
            child: Container(
              padding: EdgeInsets.all(20),
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
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    children: <Widget>[
                      Text(
                        "Order id #${widget.order.code}",
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ).align(alignment: Alignment.centerLeft),
                      _DeliveryProcesses(processes: widget.order.status_history,).center(),
                      Text(
                        "Order details",
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ).align(alignment: Alignment.centerLeft),
                       SizedBox(height: 20),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   primary: false,
                      //   itemBuilder:(context, index){
                      //   return ProductWidget(product: widget.order.items[index],onTap: (){},);
                      // }, itemCount: widget.order.items.length,),
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
                      ).align(alignment: Alignment.centerLeft),
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
                      ).align(alignment: Alignment.centerLeft),
                      
                    ]
              ),
              ),
            ).center()));
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
                    Text(
                      processes[index].name ,
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 18.0,
                          ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
                if(processes[index].id==6 ||processes[index].id==7 )
                return DotIndicator(
                  color: Colors.red,
                  child: Icon(
                    Ionicons.close,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
                else
                return DotIndicator(
                  color: Color(0xff66c97f),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: processes[index].id==6 ||processes[index].id==7 ?  Colors.red : Color(0xff66c97f),
            ),
          ),
        ),
      ),
    );
  }
}
