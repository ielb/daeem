import 'dart:async';

import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/orders_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/order_widget.dart';
import 'package:ionicons/ionicons.dart';

class OrdersPage extends StatefulWidget {
  static const id = "orders";

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late OrdersProvider _ordersProvider;
  late ClientProvider _clientProvider;
  bool called = false;

  @override
  void didChangeDependencies() {
    if (!called) {
      _ordersProvider = Provider.of<OrdersProvider>(context);
      _clientProvider = Provider.of<ClientProvider>(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _getOrders();
      });

      if (mounted)
        setState(() {
          called = true;
        });
    }

    super.didChangeDependencies();
  }

  _getOrders() async {
    showDialog(
        context: context,
        builder: (context) => CircularProgressIndicator().center());
    var result =
        await _ordersProvider.getOrders(clientId: _clientProvider.client!.id!);
    Timer(Duration(milliseconds: 2500), () {
      if (result) {
        Navigator.pop(context);

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "My orders",
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
            Expanded(
              child: ListView.builder(
                itemCount: _ordersProvider.orders.length,
                itemBuilder: (context, index) {
                  return OrderCard(
                    order: _ordersProvider.orders[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
