import 'package:daeem/services/services.dart';

class StoreWidget extends StatelessWidget {
  StoreWidget({required this.title, required this.imageUrl});
  final title;
  final imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:10,right: 10,top:5,),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(Config.margane,height: 80,width: 80, fit: BoxFit.cover,),
          ),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: true,
            style: GoogleFonts.ubuntu(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ).align(alignment: Alignment.center).paddingOnly(top:5,),
        ],
      ),
    );
  }
}
