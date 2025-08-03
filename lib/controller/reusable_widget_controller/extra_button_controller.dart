import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller to manage button states
class ButtonController extends GetxController {
  // Observable list to track hover states for multiple buttons
  RxList<bool> hoverStates = <bool>[].obs;
  
  // Initialize hover states for a given number of buttons
  void initializeButtons(int count) {
    hoverStates = List.generate(count, (_) => false).obs;
  }
  
  // Toggle hover state for a specific button
  void setHover(int index, bool value) {
    if (index < hoverStates.length) {
      hoverStates[index] = value;
    }
  }
}

