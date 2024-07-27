import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';

class AppUtils {
  static Future<File?> pickFile([FileType type = FileType.audio]) async {
    try {
      final filePickerRes = await FilePicker.platform.pickFiles(
        type: type,
      );

      if (filePickerRes != null) {
        return File(filePickerRes.files.first.path ?? "");
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static String rgbToHex(Color color) {
    return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
  }

  static Color hexToColor(String hex) {
    return Color(int.parse(hex, radix: 16) + 0xFF000000);
  }
}
