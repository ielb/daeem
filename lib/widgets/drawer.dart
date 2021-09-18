import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize(context).height,
      width: screenSize(context).width*.8,

      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 150,
            width: screenSize(context).width,
            color: Config.darkBlue,
            child: Stack(
              children: [
                IconButton(icon:Icon(CupertinoIcons.clear),iconSize: 26,color:Config.white, onPressed: () {
                  Navigator.pop(context);
                },).paddingOnly(top:35).align(alignment: Alignment.topRight),
                Image.asset(
                  Config.logo_white,

                ).center().paddingOnly(top: 20),
              ],
            ),
          ),
          Text("Account",style:GoogleFonts.ubuntu(color:Config.black,fontWeight: FontWeight.w600,fontSize: 26)).align(alignment: Alignment.topLeft).paddingOnly(top: 20,left: 20),
          SizedBox(height: screenSize(context).height*.05,),
          container("My orders",Config.shoppingBag),
          container("My information",Config.user),
          Divider(),
          container("Notifications",Config.notification),
          container("Rate us",Config.rate),
          container("Refer a friend",Config.share),
          container("Help",Config.question),
          Spacer(),
          container("Log out",Config.logout).paddingOnly(bottom: 20)
        ],
      ),
    );
  }
  Widget container(String label,Widget  icon){
    return TextButton(
      child: Container(
      child: Row(
        children: [
          icon,
          SizedBox(width:20),
          Text(label,style:GoogleFonts.ubuntu(color:Config.black,fontWeight: FontWeight.w400,fontSize: 22))
        ],
      ),
    ).center(),
      onPressed: (){},
    ).paddingOnly(left:15);
  }
}
