import 'package:daeem/models/order.dart';
import 'package:daeem/services/services.dart';
import 'package:ionicons/ionicons.dart';

class OrderDetails extends StatefulWidget {
 static const String id = 'order_detail';
  final Order order;
  OrderDetails({ required this.order});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        child: Column(
          children: [ 
            Container(
              
            )
          ],),
      )
    );
  }
}