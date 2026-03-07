import 'package:inapp_self_upgrade/src/domain/entity/version_info_entity.dart';
import 'package:inapp_self_upgrade/src/domain/use_case/check_version_uc.dart';
import 'package:inapp_self_upgrade/src/domain/use_case/download_apk_uc.dart';
import 'package:inapp_self_upgrade/src/domain/use_case/install_apk_uc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

export 'src/data/models/version_info_model.dart';
export 'src/domain/entity/version_info_entity.dart';

class InappSelfUpgrade {
  InappSelfUpgrade._();
  static final InappSelfUpgrade _instance = InappSelfUpgrade._();
  static InappSelfUpgrade get to => _instance;

  void init() {}

  Future<bool> checkPermission() async {
    var status = await Permission.requestInstallPackages.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.requestInstallPackages.request();
      return false;
    } else {
      return true;
    }
  }

  Future<VersionInfo?> checkUpdate(VersionInfo versionInfo) async {
    return CheckVersionUseCase().call(versionInfo);
  }

  Future<String?> downloadApk({
    required String url,
    required String version,
    required Function(double) onProgress,
  }) async {
    return DownloadApkUseCase().call(apkUrl: url, version: version, onProgress: onProgress);
  }

  Future<void> installApk(String apkPath) async {
    return InstallApkUseCase().call(apkPath);
  }

  Future<String> getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> getFullVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version} (${packageInfo.buildNumber})';
  }
}
