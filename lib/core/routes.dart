import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../screens/draw/canvas_screen.dart';
import '../screens/ai/ai_sketch_enhancer.dart';
import '../screens/ai/filters_effects_screen.dart';
import '../screens/export/export_share_screen.dart';
import '../screens/home/gallery_screen.dart';
import '../screens/setting/app_setting_screen.dart';

class AppRoutes {
  static const home = "/home";
  static const canvas = "/canvas";
  static const aiEnhancer = "/aiEnhancer";
  static const filters = "/filters";
  static const export = "/export";
  static const gallery = "/gallery";
  static const settings = "/settings";

  static Map<String, WidgetBuilder> routes = {
    home: (_) => const HomeScreen(),
    canvas: (_) => const CanvasScreen(),
    aiEnhancer: (_) =>  AiSketchEnhancerScreen(),
    filters: (_) => FiltersEffectsScreen(),
    export: (_) =>  ExportShareScreen(),
    gallery: (_) => const GalleryScreen(),
    settings: (_) => AppSettingsScreen(),
  };
}
