import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, String> info;

  const ProfileCard({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    String imagePath = info['imagePath']!;
    String name = info['name']!;
    String rollNumber = info['rollNumber']!;
    String position = info['position']!;

    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final cardHeight = screenHeight * 0.125;
    final imageWidth = cardHeight * 0.8;

    return Card(
      elevation: 4,
      color: const Color(0xfff4f6ff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: cardHeight,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: imageWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    AutoSizeText(
                      'Roll No: $rollNumber',
                      style: const TextStyle(
                        color: Color(0xff53A2BE),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    AutoSizeText(
                      position,
                      style: const TextStyle(
                        color: Color(0xff102B3F),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
