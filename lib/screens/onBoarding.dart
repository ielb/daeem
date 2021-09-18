import 'package:daeem/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:daeem/services/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardering extends StatefulWidget {
  static const id = "boarding";

  @override
  _OnBoarderingState createState() => _OnBoarderingState();
}

class _OnBoarderingState extends State<OnBoardering> {

  LocaleProvider provider = LocaleProvider();


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LocaleProvider>(context, listen: false);
    List<PageViewModel> pages = [
      PageViewModel(
        title: AppLocalizations.of(context)!.boarding_title,
        body:AppLocalizations.of(context)!.boarding_body,
        image: Center(
          child: Image.asset(Config.shopping_cart, height: 175.0),
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.boarding_title3,
        body:AppLocalizations.of(context)!.boarding_body2,
        image: Image.asset(Config.ontheway, height: 175.0)
            .paddingOnly(top: 50)
            .center(),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.boarding_title3,
        body: AppLocalizations.of(context)!.boarding_body3,
        image: Center(
          child: Image.asset(Config.arrived, height: 175.0),
        ),
      )
    ];

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: IntroductionScreen(
          rtl: provider.locale == Locale('ar') ? true : false,
          nextColor: Config.color_1,
          skipColor: Config.white,
          doneColor: Config.white,
          dotsDecorator: DotsDecorator(
            activeColor: Config.color_1
          ),
          globalBackgroundColor: Config.white,
          pages: pages,
          showNextButton: true,
          showSkipButton: true,
          showDoneButton: true,
          next: Container(
              height: 30,
              width: 70,
              decoration: BoxDecoration(
                color:Config.white,
                  border: Border.all(
                    width: 1.5,
                    color: Config.color_1
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              child:Text( AppLocalizations.of(context)!.next, style: GoogleFonts.ubuntu(fontWeight: FontWeight.w600)).center()),
          onDone: () {
            Navigator.pushReplacementNamed(context, Login.id);
          },
          onSkip: () {
             Provider.of<AuthProvider>(context,listen: false).setOnBoardingSkipped(true);
            Navigator.pushReplacementNamed(context, Login.id);
          },
          skip:  Container(
              height: 30,
              width: 70,
              decoration: BoxDecoration(
                  color:Config.color_1,
                  borderRadius: BorderRadius.circular(10)
              ),
              child:Text( AppLocalizations.of(context)!.skip, style:  GoogleFonts.ubuntu(fontWeight: FontWeight.w600)).center()
          ),
          done:  Container(
              height: 30,
              width: 70,
              decoration: BoxDecoration(
                  color:Config.color_1,
                  borderRadius: BorderRadius.circular(10)
              ),
              child:Text( AppLocalizations.of(context)!.done, style:  GoogleFonts.ubuntu(fontWeight: FontWeight.w600)).center()
          ),
        )
        )
    );
  }
}
