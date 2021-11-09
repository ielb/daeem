

import 'package:daeem/services/services.dart';
import 'package:shimmer/shimmer.dart';

class StoreShimmer extends StatelessWidget {
  const StoreShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15)),
                ),
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade50)
            .paddingOnly(bottom: 10),
        Shimmer.fromColors(
            child: Container(
              height: 10,
              width: 70,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15)),
            ),
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50)
      ],
    );
  }
}