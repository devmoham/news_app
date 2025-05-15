import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffectCarouselSlider extends StatelessWidget {
  const ShimmerEffectCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      const  SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 7,
              backgroundColor: Colors.grey[300]!,
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              radius: 7,
              backgroundColor: Colors.grey[300]!,
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              radius: 7,
              backgroundColor: Colors.grey[300]!,
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              radius: 7,
              backgroundColor: Colors.grey[300]!,
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              radius: 7,
              backgroundColor: Colors.grey[300]!,
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              radius: 7,
              backgroundColor: Colors.grey[300]!,
            ),
          ],
        )
      ],
    );
  }
}
