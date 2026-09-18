import 'package:flutter/widgets.dart';

abstract final class Radii {
  static const double r4 = 4;
  static const double r6 = 6;
  static const double r10 = 10;
  static const double r12 = 12;
  static const double r16 = 16;
  static const double r18 = 18;
  static const double r22 = 22;

  static const rounded4 = BorderRadius.all(.circular(r4));
  static const rounded6 = BorderRadius.all(.circular(r6));
  static const rounded10 = BorderRadius.all(.circular(r10));
  static const rounded12 = BorderRadius.all(.circular(r12));
  static const rounded16 = BorderRadius.all(.circular(r16));
  static const rounded18 = BorderRadius.all(.circular(r18));
  static const rounded22 = BorderRadius.all(.circular(r22));
}
