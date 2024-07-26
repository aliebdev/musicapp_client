import 'dart:io';

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
}
