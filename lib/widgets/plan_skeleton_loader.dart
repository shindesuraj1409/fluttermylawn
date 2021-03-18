import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:shimmer/shimmer.dart';

class PlanSkeletonLoader extends StatelessWidget {
  const PlanSkeletonLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(0x33, 0x00, 0x00, 0x00),
            blurRadius: 3.0,
            spreadRadius: 0,
            offset: Offset(
              0.0,
              1.0,
            ),
          ),
          BoxShadow(
            color: Color.fromARGB(0x1E, 0x00, 0x00, 0x00),
            blurRadius: 1.0,
            spreadRadius: -1.0,
            offset: Offset(
              0.0,
              2.0,
            ),
          ),
          BoxShadow(
            color: Color.fromARGB(0x23, 0x00, 0x00, 0x00),
            blurRadius: 1.0,
            spreadRadius: 0.0,
            offset: Offset(
              0.0,
              1.0,
            ),
          ),
        ],
      ),
      child: Card(
        color: Color.alphaBlend(
            Styleguide.color_gray_3.withOpacity(0.08), Styleguide.color_gray_0),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          height: 128,
          width: double.infinity,
          child: Shimmer.fromColors(
            baseColor: Styleguide.color_gray_2,
            highlightColor: Styleguide.color_gray_1,
            enabled: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 4,
                        color: Styleguide.color_gray_0,
                      ),
                    ),
                  ),
                  height: 80,
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _bar(40),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                      ),
                      _bar(64),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                      ),
                      _bar(88),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bar(double leftSpace) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8.0,
            color: Styleguide.color_gray_0,
          ),
        ),
        Container(
          width: leftSpace,
          height: 8,
        )
      ],
    );
  }
}
