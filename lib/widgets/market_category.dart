import 'package:daeem/screens/sous_category.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
class CategoryWidget extends StatelessWidget {
  const CategoryWidget(this._categoryTitle,this._categoryImageUrl);
  final String _categoryTitle;
  final String _categoryImageUrl;



  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, Category.id);
      },
      child: Container(
        width: screenSize(context).width*.91,
        height: 150,
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
                  image: DecorationImage(image: AssetImage(_categoryImageUrl), fit: BoxFit.fitWidth,
                  )
              ),
            ).paddingOnly(bottom: 5),
            Text(_categoryTitle,style: GoogleFonts.ubuntu(fontSize: 22,fontWeight: FontWeight.w500,color: Color(0xff4A4B4D)),).paddingOnly(left: 20).align(alignment: Alignment.topLeft),
          ],
        ),
      ),
    );
  }
}
