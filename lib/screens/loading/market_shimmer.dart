import 'package:daeem/services/services.dart';
import 'package:shimmer/shimmer.dart';

class MarketLoading extends StatelessWidget {
  const MarketLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize(context).width * .91,
      height: 230,
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
      child: Column(
        children: [
          Shimmer.fromColors(
            highlightColor: Colors.grey.shade300.withOpacity(0.7),
            baseColor: Colors.grey.shade100,
            child: Container(
              height: 135,
              width: screenSize(context).width * .91,
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
            ).paddingOnly(bottom: 5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                highlightColor: Colors.grey.shade300.withOpacity(0.7),
                baseColor: Colors.grey.shade100,
                child: Container(
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                ).paddingOnly(left: 8, right: 15, top: 5),
              ),
              Spacer(),
              Shimmer.fromColors(
                highlightColor: Colors.grey.shade300.withOpacity(0.7),
                baseColor: Colors.grey.shade100,
                child: Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                ).paddingOnly(left: 8, right: 15, top: 5),
              )
            ],
          ).paddingOnly(bottom: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        highlightColor: Colors.grey.shade300.withOpacity(0.7),
                        baseColor: Colors.grey.shade100,
                        child: Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                        ).paddingOnly(right: 15, top: 5),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Shimmer.fromColors(
                        highlightColor: Colors.grey.shade300.withOpacity(0.7),
                        baseColor: Colors.grey.shade100,
                        child: Container(
                          height: 12,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                        ).paddingOnly(right: 15, top: 10),
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              Shimmer.fromColors(
                highlightColor: Colors.grey.shade300.withOpacity(0.7),
                baseColor: Colors.grey.shade100,
                child: Container(
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                ).paddingOnly(right: 15, top: 5),
              )
            ],
          ).paddingOnly(top: 5, left: 8)
        ],
      ),
    );
  }
}
