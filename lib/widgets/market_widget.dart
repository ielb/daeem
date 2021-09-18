import 'package:daeem/services/services.dart';
import 'package:daeem/widgets/rating.dart';
import 'package:flutter/cupertino.dart';
class MarketWidget extends StatelessWidget {
  const MarketWidget(this._marketTitle,this._marketImageUrl,this._marketAddress,this._marketTime,this._marketRating);
  final String _marketTitle;
  final String _marketImageUrl;
  final int _marketRating;
  final String _marketAddress;
  final String _marketTime;
  final bool _isAvailable =  true;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
          Navigator.pushNamed(context, Market.id);


      },
      child: Container(
        width: screenSize(context).width*.91,
        height: 274,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 2,
                blurRadius: 16,
                offset: Offset(0, 4),
              )
            ]
        ),
        child: Column(
          children: [
            Container(
              height: 135,
              width: screenSize(context).width*.91,
              decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(15),
                image: DecorationImage(image: AssetImage(_marketImageUrl), fit: BoxFit.fitWidth,
                    colorFilter: !_isAvailable ?  ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken) : null,
                )
              ),
            ).paddingOnly(bottom: 5),
            Row(
              children: [
                Text(_marketTitle,style: GoogleFonts.ubuntu(fontSize: 22,fontWeight: FontWeight.w500,color: Color(0xff4A4B4D)),).paddingOnly(left: 10),
                Spacer(),
                Rating((s){},_marketRating).paddingOnly(right: 10),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(CupertinoIcons.location,size: 18,color: Color(0xff4A4B4D)),
                        Text(_marketAddress,style: GoogleFonts.ubuntu(fontSize: 14,fontWeight: FontWeight.w300,color: Color(0xff4A4B4D))),
                      ],
                    ).paddingOnly(bottom:4 ),
                    Row(
                      children: [
                        Icon(CupertinoIcons.clock,size: 18,color: Color(0xff4A4B4D)).paddingOnly(right: 3),
                        Text(_marketTime,style: GoogleFonts.ubuntu(fontSize: 14,fontWeight: FontWeight.w300,color: Color(0xff4A4B4D))),
                      ],
                    ).paddingOnly(right: 45)
                  ],
                ),
                Spacer(),
                Container(
                  height: 30,
                  width: 80,

                  child:  Text(_isAvailable ? "Available" : "Closed",style:GoogleFonts.ubuntu(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.white),).center() ,
                  decoration: BoxDecoration(
                      color: _isAvailable ? Config.color_1 : Config.yellow,
                      borderRadius: BorderRadius.circular(10)
                  ),
                ).paddingOnly(right: 15,top: 5)
              ],

            ).paddingOnly(top: 5,left: 8)
          ],
        ),
      ),
    );
  }
}
