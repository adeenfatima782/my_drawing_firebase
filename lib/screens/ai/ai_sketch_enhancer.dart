// lib/screens/ai/ai_sketch_enhancer.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../widgets/glass_container.dart';

class AiSketchEnhancerScreen extends StatefulWidget {
  const AiSketchEnhancerScreen({super.key});

  @override
  State<AiSketchEnhancerScreen> createState() => _AiSketchEnhancerScreenState();
}

class _AiSketchEnhancerScreenState extends State<AiSketchEnhancerScreen> {
  String selected = "Clean";
  double intensity = 60;
  bool processing = false;
  Uint8List? previewBytes;

  Future<Uint8List?> _apply(String option, double strength) async {
    setState(() => processing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => processing = false);
    return previewBytes;
  }

  @override
  Widget build(BuildContext context) {
    final options = ["Clean", "Smooth", "Ink", "Colorize", "Enhance"];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("AI Sketch Enhancer"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFAFAFF), Color(0xFFEFF6FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                children: [
                  GlassContainer(
                    height: 300,
                    radius: 20,
                    onTap: () {},
                    child: previewBytes == null
                        ? const Center(
                      child: Text(
                        "Tap to load drawing",
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                        : Image.memory(previewBytes!, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 86,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: options.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final opt = options[i];
                        final sel = selected == opt;

                        return GestureDetector(
                          onTap: () => setState(() => selected = opt),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 120,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: sel
                                  ? Colors.white.withOpacity(0.14)
                                  : Colors.white.withOpacity(0.06),
                              border: sel
                                  ? Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.2,
                              )
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.auto_fix_high,
                                  color: sel
                                      ? Theme.of(context).primaryColor
                                      : Colors.black54,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  opt,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Text(
                                  "${intensity.toInt()}%",
                                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 6),
                  GlassContainer(
                    radius: 20,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Intensity", style: TextStyle(fontWeight: FontWeight.w600)),
                        Slider(
                          value: intensity,
                          min: 0,
                          max: 100,
                          onChanged: (v) => setState(() => intensity = v),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(onPressed: () {}, child: const Text("Cancel")),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: processing
                                  ? null
                                  : () async {
                                final res = await _apply(selected, intensity);
                                if (res != null) setState(() => previewBytes = res);
                              },
                              child: processing
                                  ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                                  : const Text("Apply"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
