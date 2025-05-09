// import 'package:ds_ai_project_ui/components/drawing_point.dart';
// import 'package:ds_ai_project_ui/components/drawing_pointer.dart';
// import 'package:flutter/material.dart';

// class DrawingBoard extends StatefulWidget {
//   const DrawingBoard({super.key});

//   @override
//   State<DrawingBoard> createState() => _DrawingBoardState();
// }

// class _DrawingBoardState extends State<DrawingBoard> {
//   Color selectedColor = Colors.black;
//   double strokeWidth = 5;
//   List<DrawingPoint> drawingPoints = [];
//   List<Color> colors = [
//     Colors.pink,
//     Colors.red,
//     Colors.black,
//     Colors.yellow,
//     Colors.amberAccent,
//     Colors.purple,
//     Colors.green,
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GestureDetector(
//           onPanStart: (details) {
//             setState(() {
//               drawingPoints.add(
//                 DrawingPoint(
//                   details.localPosition,
//                   Paint()
//                     ..color = selectedColor
//                     ..isAntiAlias = true
//                     ..strokeWidth = strokeWidth
//                     ..strokeCap = StrokeCap.round,
//                 ),
//               );
//             });
//           },
//           onPanUpdate: (details) {
//             setState(() {
//               drawingPoints.add(
//                 DrawingPoint(
//                   details.localPosition,
//                   Paint()
//                     ..color = selectedColor
//                     ..isAntiAlias = true
//                     ..strokeWidth = strokeWidth
//                     ..strokeCap = StrokeCap.round,
//                 ),
//               );
//             });
//           },
//           onPanEnd: (details) {
//             setState(() {
//               drawingPoints.add(null);
//             });
//           },
//           child: CustomPaint(
//             painter: DrawingPainter(drawingPoints),
//             child: Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//             ),
//           ),
//         ),
//         Positioned(
//             top: 40,
//             right: 30,
//             child: Row(
//               children: [
//                 Slider(
//                   min: 0,
//                   max: 40,
//                   value: strokeWidth,
//                   onChanged: (val) => setState(() => strokeWidth = val),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () => setState(() => drawingPoints = []),
//                   icon: const Icon(Icons.clear),
//                   label: const Text("Clear Board"),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//       appBar: AppBar(
//         title: const Text('WhiteBoard'),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Container(
//           color: Colors.grey[200],
//           padding: const EdgeInsets.all(10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(
//               colors.length,
//               (index) => _buildColorChose(colors[index]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
