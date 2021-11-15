
import 'package:daeem/provider/notifiation_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/notification_widget.dart';
import 'package:flutter/cupertino.dart';

class NotificationScreen extends StatefulWidget {
  static const id = "notification";

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationProvider _notificationProvider;
  bool called = false;
  @override
  void didChangeDependencies() {
    if (!called) {
      _notificationProvider = Provider.of<NotificationProvider>(context);
      setState(() {
        called = true;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.ubuntu(fontSize: 24, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if(_notificationProvider.notifications.isNotEmpty)
          TextButton(onPressed: (){
            _notificationProvider.clearNotifications();
          },
            child: Text("Clear All",style: GoogleFonts.ubuntu(fontSize: 16,color: Colors.red),).paddingOnly(right: 5),
          )
          
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(10),
          width: screenSize(context).width,
          height: screenSize(context).height,
          child: Column(
            children: [
               _notificationProvider.notifications.length!=0 ? 
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _notificationProvider.notifications.length,
                  itemBuilder: (context, index) {
                    return NotificationWidget(
                        notification: _notificationProvider.notifications.reversed.toList()[index]);
                  })

                  : Column(
                    children: [
                     
                      Image.asset(Config.notification ,height: screenSize(context).height*0.5,),
                      SizedBox(height:screenSize(context).height*.1,),
                      Center(
                        child: Text("No Notifications",style: GoogleFonts.ubuntu(fontSize: 20,color: Colors.black),),
                      )
                    ],
                  )
            ],
          ),
        ),
      ),
    );
  }
}
