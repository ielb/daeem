import 'package:daeem/services/services.dart';
import 'package:shimmer/shimmer.dart';

class CategoryLoading extends StatelessWidget {
  const CategoryLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      width: screenSize(context).width * .91,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Shimmer.fromColors(
            highlightColor: Colors.grey.shade100,
            baseColor: Colors.grey.shade200,
            child: Container(
              height: 135,
              width: screenSize(context).width * .91,
              decoration: BoxDecoration(
                color:  Colors.grey.shade300, 
                borderRadius: BorderRadius.circular(15),
              ),
            ).align(alignment: Alignment.topLeft),
          ),
          Shimmer.fromColors(
            highlightColor: Colors.grey.shade100.withOpacity(0.7),
            baseColor: Colors.grey.shade300,
            direction: ShimmerDirection.rtl,
            child: Container(
              height: 15,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
            ).paddingAll(20).align(alignment: Alignment.topLeft),
          ),
        ],
      ),
    );
  }
}
