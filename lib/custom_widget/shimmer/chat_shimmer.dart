import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatShimmerLoader extends StatelessWidget {
  const ChatShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8, // Number of shimmer items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                CircleAvatar(radius: 24, backgroundColor: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, width: 150, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(height: 10, width: 100, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
