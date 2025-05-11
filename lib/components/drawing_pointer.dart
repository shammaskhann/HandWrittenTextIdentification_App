import 'dart:ui';

import 'package:ds_ai_project_ui/components/drawing_point.dart';
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  DrawingPainter(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    final List<Offset> offsetsList = [];

    for (int i = 0; i < drawingPoints.length - 1; i++) {
      final currentPoint = drawingPoints[i];
      final nextPoint = drawingPoints[i + 1];

      if (currentPoint != null && nextPoint != null) {
        canvas.drawLine(
          currentPoint.offset,
          nextPoint.offset,
          currentPoint.paint,
        );
      } else if (currentPoint != null && nextPoint == null) {
        offsetsList.clear();
        offsetsList.add(currentPoint.offset);
        canvas.drawPoints(
          PointMode.points,
          offsetsList,
          currentPoint.paint,
        );
      }
    }

    if (drawingPoints.isNotEmpty && drawingPoints.last != null) {
      offsetsList.clear();
      offsetsList.add(drawingPoints.last!.offset);
      canvas.drawPoints(
        PointMode.points,
        offsetsList,
        drawingPoints.last!.paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
