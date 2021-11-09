import 'package:daeem/models/notification.dart' as notif;
import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/notification_widget.dart';
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
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(10),
          width: screenSize(context).width,
          height: screenSize(context).height,
          child: Column(
            children: [
              ListView.builder(
                
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return NotificationWidget(
                        notification: notif.Notification(
                            id: '1',
                            title: "Discout %",
                            body: "-15% for the new users"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
