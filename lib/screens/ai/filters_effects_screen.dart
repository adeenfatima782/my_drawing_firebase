import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../widgets/glass_container.dart';
import '../../services/image_filters.dart';

class FiltersEffectsScreen extends StatefulWidget {
  @override
  _FiltersEffectsScreenState createState() => _FiltersEffectsScreenState();
}

class _FiltersEffectsScreenState extends State<FiltersEffectsScreen> {
  double brightness = 50;
  double contrast = 50;
  double saturation = 50;

  Uint8List? previewBytes; // load bytes from canvas/gallery

  String selectedFilter = "None";
  final filters = ["None", "Vibrant", "Vintage", "Pastel", "Mono", "Cartoon", "HDR"];

  bool processing = false;

  Future<void> _applyAdjustments() async {
    if (previewBytes == null) return;
    setState(() => processing = true);

    Uint8List bytes = previewBytes!;

    if (selectedFilter != "None") {
      bytes = await ImageFilters.applyPreset(bytes, selectedFilter);
    }

    bytes = await ImageFilters.applyBrightness(bytes, (brightness - 50).toInt());
    bytes = await ImageFilters.applyContrast(bytes, (contrast - 50).toInt());
    bytes = await ImageFilters.applySaturation(bytes, (saturation - 50).toInt());

    setState(() {
      previewBytes = bytes;
      processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Filters & Effects"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [

              // 🔥 FIXED — radius added
              GlassContainer(
                height: 280,
                radius: 20,
                child: previewBytes == null
                    ? Center(child: Text("Select a drawing"))
                    : Image.memory(previewBytes!, fit: BoxFit.contain),
                onTap: () {
                  // open canvas/gallery
                },
              ),

              SizedBox(height: 12),

              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final f = filters[i];
                    final sel = selectedFilter == f;

                    return GestureDetector(
                      onTap: () => setState(() => selectedFilter = f),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        width: 110,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: sel
                              ? Colors.white.withOpacity(0.12)
                              : Colors.white.withOpacity(0.06),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.filter,
                                size: 28,
                                color: sel
                                    ? Theme.of(context).primaryColor
                                    : Colors.black54),
                            Spacer(),
                            Text(f, style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 10),

              // 🔥 FIXED — radius added
              GlassContainer(
                radius: 20,
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    _sliderRow("Brightness", brightness,
                            (v) => setState(() => brightness = v)),
                    _sliderRow("Contrast", contrast,
                            (v) => setState(() => contrast = v)),
                    _sliderRow("Saturation", saturation,
                            (v) => setState(() => saturation = v)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              setState(() {
                                brightness = 50;
                                contrast = 50;
                                saturation = 50;
                                selectedFilter = "None";
                              });
                            },
                            child: Text("Reset")),

                        SizedBox(width: 8),

                        ElevatedButton(
                          onPressed: processing ? null : () async {
                            await _applyAdjustments();
                          },
                          child: processing
                              ? SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ))
                              : Text("Apply"),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sliderRow(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ${value.toInt()}"),
        Slider(value: value, min: 0, max: 100, onChanged: onChanged),
        SizedBox(height: 8),
      ],
    );
  }
}
