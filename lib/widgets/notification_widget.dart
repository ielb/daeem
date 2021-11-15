import 'package:daeem/services/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:daeem/models/notification.dart' as notif;

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({required this.notification, Key? key})
      : super(key: key);
  final notif.Notification notification;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only( bottom: 15),
      padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
      width: screenSize(context).width * .9,
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200.withOpacity(0.6),
              spreadRadius: 2,
              blurRadius: 16,
              offset: Offset(0, 4),
            )
          ]),
      child: Row(
        children: [
          Icon(
            Ionicons.notifications,
            color: Config.color_2,
            size: 28,
          ).paddingOnly(right: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 250,
                child: Text(
                  "${notification.title}",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.ubuntu(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                width: 250,
                child: Text(
                  "${notification.body}",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.ubuntu(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
