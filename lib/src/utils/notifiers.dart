import 'package:flutter/material.dart';

class CounterNotifier extends ValueNotifier<int> {
  CounterNotifier({int? value}) : super(value ?? 0);

  void increment() {
    value++;
  }

  void decrement() {
    if (value > 0) {
      value--;
    } else {
      value;
    }
  }
}

class RadioNotifier extends ValueNotifier<int> {
  RadioNotifier({int? value}) : super(value ?? -1);

  void select(int val) {
    value = val;
  }
}
