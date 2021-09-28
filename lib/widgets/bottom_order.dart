import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/services/services.dart';

class StickyOrder extends StatelessWidget {
  
  StickyOrder({required this.child}); 
  final Widget child ;

  @override
  Widget build(BuildContext context) {
     var cart = Provider.of<CartProvider>(context, listen: false);
    return Stack(
      children: [
        child,
        if(cart.basket.isNotEmpty)
        Container(
          height: 50,
          width: screenSize(context).width + .9,
          decoration: BoxDecoration(
              color: Config.color_2, borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Order now",
                style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ).paddingOnly(left: 15),
              Spacer(),
              Text("Total: 3300 MAD",
                      style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600))
                  .paddingOnly(right: 15)
            ],
          ),
        ).paddingAll(30).align(alignment: Alignment.bottomCenter),
      ],
    );
  }
}
