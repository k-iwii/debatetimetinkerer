import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollapsibleMenu extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget? content;

  const CollapsibleMenu({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    this.content,
  });

  String _wrapTitle(String title) {
    if (title.length <= 28) return title;

    // Find the last space before or at position 28
    int lastSpaceIndex = -1;
    for (int i = 0; i < 28 && i < title.length; i++) {
      if (title[i] == ' ') {
        lastSpaceIndex = i;
      }
    }

    // If we found a space, insert newline before the last word
    if (lastSpaceIndex != -1) {
      return '${title.substring(0, lastSpaceIndex)}\n${title.substring(lastSpaceIndex + 1)}';
    }

    // If no space found, just return the original title
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                _wrapTitle(title),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
        if (isExpanded)
          Container(
            child: content ??
                Text(
                  'Options will go here...',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
          ),
      ],
    );
  }
}
