import 'package:daeem/services/services.dart';
import 'package:shimmer/shimmer.dart';

class ProductLoading extends StatelessWidget {
  const ProductLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize(context).width * .91,
      height: 80,
      padding: EdgeInsets.all(10),
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
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
             highlightColor: Colors.grey.shade100,
            baseColor: Colors.grey.shade200,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 2,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    )
                  ]),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                 highlightColor: Colors.grey.shade100,
                baseColor: Colors.grey.shade200,
                child: Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 2,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Shimmer.fromColors(
                 highlightColor: Colors.grey.shade100,
                baseColor: Colors.grey.shade200,
                child: Container(
                  width: 50,
                  height: 12,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 2,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        )
                      ]),
                ),
              ),
            ],
          ),
          Spacer(),
          Shimmer.fromColors(
            highlightColor: Colors.grey.shade100,
            baseColor: Colors.grey.shade200,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 2,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
