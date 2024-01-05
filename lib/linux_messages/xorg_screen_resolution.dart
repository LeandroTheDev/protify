// No seu código Dart
import 'package:flutter/services.dart';

const resolutionChannel = MethodChannel('getScreenResolution');

class XorgResolution {
  Future<Map<String, dynamic>> getScreenResolution() async {
    try {
      final result = await resolutionChannel.invokeMethod('getScreenResolution');
      return result.cast<String, dynamic>();
    } on PlatformException catch (e) {
      throw 'Xorg Screen Resolution Error: ${e.message}';
    }
  }
}
