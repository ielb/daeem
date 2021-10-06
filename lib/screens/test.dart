
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screenSize(context).height,
        width: screenSize(context).width,
        child: SingleChildScrollView(
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
          ]
          ,
        ),
        ),
      ),
    );
  }
}
