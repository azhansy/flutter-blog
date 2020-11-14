import 'platform_dector.dart';
import 'dart:io';

PlatformType get currentType {
  if (Platform.isIOS) return PlatformType.IOS;
  if (Platform.isAndroid) return PlatformType.Android;
  if(Platform.isFuchsia || Platform.isLinux || Platform.isMacOS || Platform.isWindows) return PlatformType.Desktop;
  return PlatformType.Mobile;
}
