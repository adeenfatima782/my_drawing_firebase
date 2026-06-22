// lib/services/filter_service.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class FilterService {
  // Apply grayscale filter
  static ColorFilter grayscale() {
    return const ColorFilter.matrix(<double>[
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0,      0,      0,      1, 0,
    ]);
  }

  // Apply sepia filter
  static ColorFilter sepia() {
    return const ColorFilter.matrix(<double>[
      0.393, 0.769, 0.189, 0, 0,
      0.349, 0.686, 0.168, 0, 0,
      0.272, 0.534, 0.131, 0, 0,
      0,     0,     0,     1, 0,
    ]);
  }

  // Apply invert filter
  static ColorFilter invert() {
    return const ColorFilter.matrix(<double>[
      -1, 0, 0, 0, 255,
      0, -1, 0, 0, 255,
      0, 0, -1, 0, 255,
      0, 0, 0, 1, 0,
    ]);
  }

  // Apply brightness filter (value: -1.0 to 1.0)
  static ColorFilter brightness(double value) {
    return ColorFilter.matrix(<double>[
      1, 0, 0, 0, 255 * value,
      0, 1, 0, 0, 255 * value,
      0, 0, 1, 0, 255 * value,
      0, 0, 0, 1, 0,
    ]);
  }

  // Apply contrast filter (value: 0.0 to 4.0, 1.0 = normal)
  static ColorFilter contrast(double value) {
    double t = 128 * (1 - value);
    return ColorFilter.matrix(<double>[
      value, 0, 0, 0, t,
      0, value, 0, 0, t,
      0, 0, value, 0, t,
      0, 0, 0, 1, 0,
    ]);
  }
}
