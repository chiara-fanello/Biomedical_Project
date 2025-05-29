import 'sleepdata.dart';
import 'package:flutter/material.dart';

class SleepBarChart extends StatelessWidget {
  final List<SleepSegment> segments;

  const SleepBarChart({super.key, required this.segments});

  static const stageLabels = {
    SleepStage.deep: "Deep",
    SleepStage.light: "Light",
    SleepStage.rem: "REM",
    SleepStage.awake: "Awake",
  };

  static const stageColors = {
    SleepStage.deep: Colors.green,
    SleepStage.light: Colors.blue,
    SleepStage.rem: Colors.orange,
    SleepStage.awake: Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    // Calculate overall sleep time range
    final startTime = segments
        .map((s) => s.start)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final endTime = segments
        .map((s) => s.end)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final totalMinutes = endTime.difference(startTime).inMinutes;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: totalMinutes * 2, // Wider for better readability
        height: 280,
        child: CustomPaint(
          painter: _SleepBarChartPainter(
            segments: segments,
            startTime: startTime,
            endTime: endTime,
            stageColors: stageColors,
          ),
        ),
      ),
    );
  }
}

class _SleepBarChartPainter extends CustomPainter {
  final List<SleepSegment> segments;
  final DateTime startTime;
  final DateTime endTime;
  final Map<SleepStage, Color> stageColors;

  _SleepBarChartPainter({
    required this.segments,
    required this.startTime,
    required this.endTime,
    required this.stageColors,
  });

  final stageOrder = [
    SleepStage.awake,
    SleepStage.rem,
    SleepStage.light,
    SleepStage.deep,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final totalMinutes = endTime.difference(startTime).inMinutes;

    final rowHeight = (size.height / stageOrder.length) * 0.6;
    final textPainter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.rtl,
    );

    // Draw Y-axis labels
    for (int i = 0; i < stageOrder.length; i++) {
      final label = SleepBarChart.stageLabels[stageOrder[i]]!;
      textPainter.text = TextSpan(
        text: label,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(0, i * rowHeight + (rowHeight - textPainter.height) / 2),
      );
    }

    final xOffset = 60.0; // Leave space for Y-axis labels

    for (var segment in segments) {
      final stageIndex = stageOrder.indexOf(segment.stage);
      final top = stageIndex * rowHeight + 4;
      final barHeight = rowHeight;

      final startMinutes = segment.start.difference(startTime).inMinutes;
      final endMinutes = segment.end.difference(startTime).inMinutes;

      final overlap = 2.0;
      const shrink = 2.0;

      final left =
          xOffset +
          (startMinutes / totalMinutes) * (size.width - xOffset) +
          shrink;
      final right =
          xOffset +
          (endMinutes / totalMinutes) * (size.width - xOffset) +
          overlap -
          shrink;

      paint.color = stageColors[segment.stage] ?? Colors.black;
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTRB(left, top, right, top + barHeight),
        Radius.circular(6),
      );

      // Light shadow under bar
      canvas.drawShadow(
        Path()..addRRect(rrect),
        Colors.black.withOpacity(0.2),
        2.0,
        false,
      );

      // Rounded colored bar
      paint.color = stageColors[segment.stage]!.withOpacity(0.9);
      canvas.drawRRect(rrect, paint);
    }

    // Draw X-axis time labels

    final labelStyle = TextStyle(color: Colors.black, fontSize: 10);

    const tickInterval = 45; // Minutes between labels (e.g. every 45 mins)

    for (int i = 0; i <= totalMinutes; i += tickInterval) {
      final tickTime = startTime.add(Duration(minutes: i));
      final label =
          "${tickTime.hour.toString().padLeft(2, '0')}:${tickTime.minute.toString().padLeft(2, '0')}";

      final x = xOffset + (i / totalMinutes) * (size.width - xOffset);
      final tp = TextPainter(
        text: TextSpan(text: label, style: labelStyle),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - tp.height - 50));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
