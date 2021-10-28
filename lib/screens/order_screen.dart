import 'package:daeem/services/services.dart';
import 'package:ionicons/ionicons.dart';

class OrdersPage extends StatefulWidget {
 static const id = "orders";

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Ionicons.chevron_back),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: screenSize(context).width,
      ),
    );
  }
}