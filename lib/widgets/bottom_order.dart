import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/screens/checkout_screen.dart';
import 'package:daeem/screens/login.dart';
import 'package:daeem/services/services.dart';

class StickyOrder extends StatelessWidget {
  StickyOrder({required this.child, required this.mcontext});
  final Widget child;
  final BuildContext mcontext;

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context, listen: false);
    var auth = Provider.of<AuthProvider>(context, listen: false);
    return Stack(
      children: [
        child,
        if (!cart.isCartEmpty())
          TweenAnimationBuilder(
              tween: Tween(
                  begin: screenSize(context).height - 50,
                  end: screenSize(context).height - 150),
              duration: Duration(milliseconds: 700),
              builder: (_, double d, __) {
                return Positioned(
                  top: d,
                  right: -20,
                  left: -20,
                  child: GestureDetector(
                    onTap: () {
                      if (auth.isAuth()) {
                        Navigator.pushNamed(mcontext, CheckoutPage.id);
                      } else {
                        Toast.show("Please Sign in", context, duration: 4);
                        Navigator.pushNamed(mcontext, Login.id,
                            arguments: true);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(30),
                      height: 50,
                      width: screenSize(context).width + .9,
                      decoration: BoxDecoration(
                          color: Config.color_2,
                          borderRadius: BorderRadius.circular(15)),
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
                          Text("Total: ${cart.getFinalPrice()} MAD",
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                              .paddingOnly(right: 15)
                        ],
                      ),
                    ).paddingAll(30),
                  ),
                );
              }),
      ],
    );
  }
}
