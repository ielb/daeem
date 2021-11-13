import 'package:daeem/models/order.dart';
import 'package:daeem/screens/order_details_screen.dart';
import 'package:daeem/services/services.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class OrderCard extends StatelessWidget {
  OrderCard({
    required this.order,
  });
  final Order order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, OrderDetails.id, arguments: order);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 100,
        width: screenSize(context).width * .95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:5, left: 10),
                  child: RichText(
                      text: TextSpan(
                        text:  "Order id : ",
                  style: GoogleFonts.ubuntu(
                      fontSize: 16, fontWeight: FontWeight.w400,color: Colors.grey),
                        children: [
                    TextSpan(
                      text: '# ${order.code}',
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                        ,color: Colors.black
                      ),
                    ),
                  ])),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10, top: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    color:Config.getStatusSubColor(order.current_status.color),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                    "${order.current_status.name}",
                    style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color:Config.getStatusColor(order.current_status.color),
                        fontWeight: FontWeight.w600),
                  )),
                )
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${order.store?.name??''}",
                    style: GoogleFonts.ubuntu(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Text(
                    "${DateFormat("EEE, d MMM yyyy").format(DateTime.parse(order.created_at))}",
                    style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Total : ${order.order_price} DH",
                    style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Icon(
                      Ionicons.chevron_forward,
                      color: Colors.black54,
                    )),
              ],
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
