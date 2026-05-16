import 'dart:io';

import 'package:dio/dio.dart';

class VersionInfoRemoteSource {
  final Dio _dio = Dio();

  Future<String> downloadApk(String url, String version, Function(double) onProgress) async {
    try {
      final dir = Directory('/storage/emulated/0/Download');

      // မှတ်ချက်: ကိုယ့် App ကိုယ်သိအောင် နာမည်ရှေ့မှာ Prefix တစ်ခုခု တပ်ပါ
      const String appPrefix = 'TaxiDriver_';
      final savePath = '${dir.path}/$appPrefix$version.apk';

      final file = File(savePath);
      // အခု ဒေါင်းမယ့် Version အသစ် ရှိနေပြီးသားဆိုရင် တန်းပြီး အလုပ်လုပ်မယ်
      if (await file.exists()) {
        onProgress(1.0);
        return savePath;
      }

      // အဟောင်းတွေကို လိုက်ဖျက်မယ့် အပိုင်း
      if (await dir.exists()) {
        try {
          final List<FileSystemEntity> files = dir.listSync();
          for (var fileEntity in files) {
            // .apk တွေအကုန်မဖျက်ဘဲ၊ ကိုယ့် App ရဲ့ နာမည်ပါတဲ့ အဟောင်းတွေကိုပဲ ဖျက်မယ်
            if (fileEntity is File && fileEntity.path.contains(appPrefix) && fileEntity.path.endsWith('.apk')) {
              await fileEntity.delete();
            }
          }
        } catch (e) {
          // Android 11+ မှာ Permission ကြောင့် ဖျက်မရရင် ကျော်သွားမယ်၊ App မ Crash တော့ဘူး
          print('Could not delete old APKs due to OS restriction: $e');
        }
      }

      // အသစ်ကို Download ဆွဲမယ်
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );
      return savePath;
    } catch (e) {
      rethrow;
    }
  }
}
