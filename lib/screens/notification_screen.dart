

import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class NotificationScreen extends StatefulWidget {
 static const id = "notification";

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(CupertinoIcons.back),color: Colors.black,onPressed: (){
          Navigator.pop(context);
        },),
        title: Text("Notifications",style: GoogleFonts.ubuntu(fontSize: 24,color:Colors.black),),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(padding: EdgeInsets.all(10),
        width: screenSize(context).width,
      ),
    );
  }
}