import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherController extends GetxController {
  final GlobalKey<FormState> singinFormKey =
      GlobalKey<FormState>(debugLabel: '__singinFormKey__');
  final _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  void onTabChange(int index) {
    print('Changing to tab index $index');
    _selectedIndex.value = index;
  }
}
