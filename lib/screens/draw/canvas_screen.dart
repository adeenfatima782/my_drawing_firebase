import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/drawing_controller.dart';
import '../../widgets/custom_button.dart';

class CanvasScreen extends StatefulWidget {
  final String? toolId;
  const CanvasScreen({super.key, this.toolId});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  final GlobalKey canvasKey = GlobalKey();
  late ConfettiController _confettiController;

  Color selectedColor = Colors.white;
  double brushSize = 5.0;
  String selectedEffect = 'Normal';
  bool isRainbowMode = false;

  List<DrawingPoint?> points = [];
  List<DrawingPoint?> history = [];

  bool _isSaving = false;
  bool _isAIProcessing = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _applyInitialTool();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _applyInitialTool() {
    if (widget.toolId == 'marker') {
      selectedColor = Colors.blueAccent;
      brushSize = 15.0;
    } else if (widget.toolId == 'eraser') {
      selectedColor = const Color(0xff060912);
      brushSize = 35.0;
    }
  }

  // --- SHARE LOGIC ---
  void _shareDrawing() async {
    try {
      final bytes = await _captureCanvas();
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/magic_art_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(path)],
        text: 'Look at my Magic Art! 🎨✨',
      );
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }

  Paint _getPaintStyle(Color currentPointColor) {
    Paint paint = Paint()
      ..color = isRainbowMode ? currentPointColor : selectedColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = brushSize
      ..isAntiAlias = true;

    if (selectedEffect == 'Neon') {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    } else if (selectedEffect == 'Glitter') {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.outer, 7);
    } else if (selectedEffect == 'Shaded') {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.inner, 4);
    }
    return paint;
  }

  void _undo() {
    if (points.isNotEmpty) {
      setState(() {
        history.add(points.removeLast());
        while (points.isNotEmpty && points.last != null) {
          history.add(points.removeLast());
        }
      });
    }
  }

  Future<Uint8List> _captureCanvas() async {
    RenderRepaintBoundary boundary = canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _saveCanvas(AuthController auth, DrawingController dCtrl) async {
    if (points.isEmpty) return;
    setState(() => _isSaving = true);

    try {
      final bytes = await _captureCanvas();
      await dCtrl.saveDrawing(bytes: bytes, ownerId: auth.currentUser?.id);

      _confettiController.play();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("✨ Art Saved to Gallery!", style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.deepPurpleAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        );

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      debugPrint("Save Error: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final dCtrl = context.read<DrawingController>();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          backgroundColor: const Color(0xff060912),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text("CANVAS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 4, fontSize: 18)),
            leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20)),
            actions: [
              // FIXED SHARE BUTTON
              IconButton(
                onPressed: _shareDrawing,
                icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
              ),
              TextButton(
                onPressed: () async {
                  setState(() => _isAIProcessing = true);
                  final bytes = await _captureCanvas();
                  await dCtrl.enhanceImage(bytes);
                  if (mounted) setState(() => _isAIProcessing = false);
                },
                child: Text(_isAIProcessing ? "..." : "AI MAGIC", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildEffectBar(),
              Expanded(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      Color rainbowColor = HSVColor.fromAHSV(1.0, (points.length % 360).toDouble(), 1.0, 1.0).toColor();
                      points.add(DrawingPoint(renderBox.globalToLocal(details.globalPosition), _getPaintStyle(rainbowColor)));
                    });
                  },
                  onPanEnd: (_) => setState(() { points.add(null); history.clear(); }),
                  child: RepaintBoundary(key: canvasKey, child: CustomPaint(size: Size.infinite, painter: CanvasPainter(pointsList: points))),
                ),
              ),
              _buildBottomPanel(auth, dCtrl),
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.purple, Colors.blue, Colors.pink, Colors.amber],
        ),
      ],
    );
  }

  Widget _buildEffectBar() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: ["Normal", "Neon", "Glitter", "Shaded", "Rainbow"].map((e) => GestureDetector(
          onTap: () => setState(() { if (e == "Rainbow") isRainbowMode = !isRainbowMode; else { selectedEffect = e; isRainbowMode = false; } }),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: (e == "Rainbow" && isRainbowMode) || (selectedEffect == e && !isRainbowMode) ? Colors.blueAccent : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(child: Text(e, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildBottomPanel(auth, dCtrl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: const BoxDecoration(color: Color(0xff161B2E), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _toolIcon(Icons.undo_rounded, "Undo", () => _undo()),
              _toolIcon(Icons.edit_rounded, "Pencil", () => setState(() { brushSize = 4; selectedColor = Colors.white; isRainbowMode = false; })),
              _toolIcon(Icons.brush_rounded, "Marker", () => setState(() { brushSize = 15; selectedColor = Colors.blueAccent; isRainbowMode = false; })),
              _toolIcon(Icons.auto_fix_high_rounded, "Eraser", () => setState(() { brushSize = 35; selectedColor = const Color(0xff060912); isRainbowMode = false; })),
              _toolIcon(Icons.delete_sweep_rounded, "Clear", () => setState(() => points.clear())),
            ],
          ),
          Slider(value: brushSize, min: 1, max: 50, activeColor: Colors.blueAccent, onChanged: (v) => setState(() => brushSize = v)),
          _buildFullColorRow(),
          const SizedBox(height: 20),
          CustomButton(text: _isSaving ? 'SAVING...' : 'SAVE ART', onPressed: () => _saveCanvas(auth, dCtrl)),
        ],
      ),
    );
  }

  Widget _toolIcon(IconData icon, String label, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Column(children: [Icon(icon, color: Colors.white60, size: 22), Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8))]));

  Widget _buildFullColorRow() {
    List<Color> palette = [Colors.white, Colors.red, Colors.pink, Colors.purple, Colors.blue, Colors.cyan, Colors.green, Colors.yellow, Colors.orange, Colors.brown];
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: palette.map((c) => GestureDetector(onTap: () => setState(() { selectedColor = c; isRainbowMode = false; }), child: Container(margin: const EdgeInsets.symmetric(horizontal: 5), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: selectedColor == c ? Colors.blueAccent : Colors.transparent, width: 2)), child: CircleAvatar(backgroundColor: c, radius: 12)))).toList()));
  }
}

class DrawingPoint { Offset offset; Paint paint; DrawingPoint(this.offset, this.paint); }
class CanvasPainter extends CustomPainter {
  final List<DrawingPoint?> pointsList;
  CanvasPainter({required this.pointsList});
  @override void paint(Canvas canvas, Size size) { for (int i = 0; i < pointsList.length - 1; i++) { if (pointsList[i] != null && pointsList[i + 1] != null) { canvas.drawLine(pointsList[i]!.offset, pointsList[i + 1]!.offset, pointsList[i]!.paint); } } }
  @override bool shouldRepaint(CanvasPainter oldDelegate) => true;
}