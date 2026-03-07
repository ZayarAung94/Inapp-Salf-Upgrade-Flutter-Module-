import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ApkInstallService {
  static const platform = MethodChannel('com.taximeter/install');

  Future<void> installApk(String filePath) async {
    try {
      await platform.invokeMethod('installApk', {'filePath': filePath});
    } on PlatformException catch (e) {
      debugPrint("Install Error: ${e.message}");
    }
  }
}
