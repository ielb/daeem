import 'package:daeem/services/services.dart';

class StoreWidget extends StatelessWidget {
   StoreWidget({required this.title,required this.imageUrl}) ;
   final title;
   final imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 160,
      width: 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 16,
              offset: Offset(0, 4),
            )
          ]),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 100,
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(imageUrl),
          ),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: true,
            style: GoogleFonts.ubuntu(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ).align(alignment: Alignment.center).paddingOnly(bottom: 10),
        ],
      ),
    );
  }
}
