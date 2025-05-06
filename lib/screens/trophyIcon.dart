import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'trophyPage.dart';

class TrophyIcon extends StatelessWidget {
  final Trophy trophy;

  const TrophyIcon({super.key, required this.trophy});

  Color _getLevelColor(TrophyLevel level) {
    switch (level) {
      case TrophyLevel.gold:
        return Color(0xFFFFD700); // oro
      case TrophyLevel.silver:
        return Color(0xFFC0C0C0); // argento
      case TrophyLevel.bronze:
        return Color(0xFFCD7F32); // bronzo
      case TrophyLevel.wood:
      default:
        return Color(0xFF8B4513); // legno
    }
  }

  double _getLevelProgress(Trophy trophy) {
    switch (trophy.level) {
      case TrophyLevel.gold:
        return 1.0;
      case TrophyLevel.silver:
        return (trophy.progress - 10) / (50 - 10);
      case TrophyLevel.bronze:
        return (trophy.progress - 5) / (10 - 5);
      case TrophyLevel.wood:
        return trophy.progress / 5;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getLevelColor(trophy.level);
    final progress = _getLevelProgress(trophy).clamp(0.0, 1.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: SvgPicture.asset(
            'assets/icons/${trophy.icon}',
            width: 48,
            height: 48,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Text(
          trophy.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
