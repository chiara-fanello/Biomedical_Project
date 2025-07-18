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
    SleepStage.deep: Color(0xFF81C784), // verde menta
    SleepStage.light: Color(0xFF64B5F6), // azzurro
    SleepStage.rem: Color(0xFFFFB74D), // arancio chiaro
    SleepStage.awake: Color(0xFFE57373), // rosso tenue
  };

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) {
      return Center(
        child: Text(
          'No sleep data available',
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    final startTime = segments
        .map((s) => s.start)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final endTime = segments
        .map((s) => s.end)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final totalMinutes = endTime.difference(startTime).inMinutes;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;

        return Container(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: chartWidth,
            height: 120,
            child: CustomPaint(
              painter: _SleepBarChartPainter(
                segments: segments,
                startTime: startTime,
                endTime: endTime,
                stageColors: stageColors,
                chartWidth: chartWidth,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SleepBarChartPainter extends CustomPainter {
  final List<SleepSegment> segments;
  final DateTime startTime;
  final DateTime endTime;
  final Map<SleepStage, Color> stageColors;
  final double chartWidth;

  _SleepBarChartPainter({
    required this.segments,
    required this.startTime,
    required this.endTime,
    required this.stageColors,
    required this.chartWidth,
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
    final xOffset = 27.0;
    final effectiveChartWidth = chartWidth - xOffset;
    final rowHeight = (size.height - 65) / stageOrder.length;

    final labelStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    final textPainter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    // Linee guida orizzontali + etichette
    for (int i = 0; i < stageOrder.length; i++) {
      final y = i * rowHeight;

      // Linea guida
      paint.color = Colors.grey.shade300;
      paint.strokeWidth = 1;
      canvas.drawLine(
        Offset(xOffset, y + rowHeight / 2),
        Offset(size.width, y + rowHeight / 2),
        paint,
      );

      // Etichetta
      final label = SleepBarChart.stageLabels[stageOrder[i]]!;
      textPainter.text = TextSpan(text: label, style: labelStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-16, y + rowHeight / 2 - textPainter.height / 2),
      );
    }

    // Disegna segmenti
    for (var segment in segments) {
      final stageIndex = stageOrder.indexOf(segment.stage);
      final yTop = stageIndex * rowHeight + rowHeight * 0.2;
      final barHeight = rowHeight * 0.5;

      final startMinutes = segment.start.difference(startTime).inMinutes;
      final endMinutes = segment.end.difference(startTime).inMinutes;

      final left =
          xOffset + (startMinutes / totalMinutes) * effectiveChartWidth;
      final right = xOffset + (endMinutes / totalMinutes) * effectiveChartWidth;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTRB(left, yTop, right, yTop + barHeight),
        const Radius.circular(8),
      );

      // Ombra soft
      canvas.drawShadow(
        Path()..addRRect(rrect),
        Colors.black.withOpacity(0.12),
        3,
        false,
      );

      // Riempimento
      paint.color = stageColors[segment.stage]!.withOpacity(0.85);
      canvas.drawRRect(rrect, paint);
    }

    // Etichette orarie (asse X)
    const tickInterval = 60;
    final timeLabelStyle = const TextStyle(color: Colors.grey, fontSize: 10);

    for (int i = 0; i <= totalMinutes; i += tickInterval) {
      final tickTime = startTime.add(Duration(minutes: i));
      final label = "${tickTime.hour.toString().padLeft(2, '0')}:00";
      final x = xOffset + (i / totalMinutes) * chartWidth;

      final tp = TextPainter(
        text: TextSpan(text: label, style: timeLabelStyle),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 50));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
