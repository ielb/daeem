import 'package:daeem/services/services.dart';

class LostConnection extends StatelessWidget {
 static const id = "connection";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screenSize(context).height,
        width: screenSize(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50,),
          Image.asset( "assets/offline.png",height: 300,width: 300, ),
          SizedBox(height: 50,),
          Text("You are offline",style: GoogleFonts.ubuntu(fontSize:24,fontWeight: FontWeight.w600)),
          Container(
            padding: EdgeInsets.all(20),
            width: 340,
            child: Text(
              "It seems there are a problem in  your connection. Please check again ",
              style: GoogleFonts.ubuntu(color: Colors.black54,fontSize:18,fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          ),
         Spacer(),
          ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context,Splash.id);
                    },
                    child: Text(
                      "Try again",
                      style: GoogleFonts.ubuntu(fontSize: 20,fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                        shadowColor: Config.color_1,
                        primary: Config.color_1,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15),
                        ),
                        fixedSize: Size(screenSize(context).width * .8, 50)),
                  )
                      .paddingOnly(top: 20, bottom: 20),
        ]
        ,
        ),
      ),
    );
  }
}