import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/screens/cart_screen.dart';
import 'package:daeem/screens/login.dart';
import 'package:daeem/services/services.dart';

class StickyOrder extends StatelessWidget {
  StickyOrder({required this.child, required this.mcontext, });
  final Widget child;
  final BuildContext mcontext;
  

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    var cart = Provider.of<CartProvider>(context);
    return Stack(
      children: [
        child,
        if (!cart.isCartEmpty())
          TweenAnimationBuilder(
              tween: Tween(
                  begin: screenSize(context).height - 50,
                  end: screenSize(context).height - 120),
              duration: Duration(milliseconds: 300),
              builder: (_, double d, __) {
                return Positioned(
                  top: d,
                  right: -30,
                  left: 170,
                  child: GestureDetector(
                    onTap: () {
                      if (auth.isAuth()) {
                        Navigator.pushNamed(mcontext, CartPage.id);
                      } else {
                        Toast.show("Please Sign in", context, duration: 4);
                        Navigator.pushNamed(mcontext, Login.id,
                            arguments: true);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(30),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Config.color_2.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "View cart",
                            style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ).paddingOnly(left: 15),
                          Spacer(),
                          Container(
                            
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Config.color_1,
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(
                              child: Text("${cart.basket.length}",
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700))
                                  
                            ),
                          ).paddingOnly(right: 10)
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
