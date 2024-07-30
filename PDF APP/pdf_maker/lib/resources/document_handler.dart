// // document_handler.dart
// import 'package:file_picker/file_picker.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';

// class DocumentHandler {
//   static final DocumentHandler _instance = DocumentHandler._internal();
//   factory DocumentHandler() => _instance;

//   DocumentHandler._internal();

//   Future<PermissionStatus> storagePermissionStatus() async {
//     PermissionStatus status = await Permission.storage.status;

//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     status = await Permission.storage.status;

//     return status;
//   }

//   Future<File?> pickDocument() async {
//     PermissionStatus status = await storagePermissionStatus();

//     if (status.isGranted) {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['doc', 'docx'],
//       );

//       if (result != null && result.files.isNotEmpty) {
//         return File(result.files.single.path!);
//       }
//     }
//     return null;
//   }

//   Future<File?> convertDocToPdf(File docFile) async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Center(
//           child: pw.Text('Converted PDF from ${docFile.path}'),
//         ),
//       ),
//     );

//     final outputDir = await Directory.systemTemp.createTemp();
//     final pdfFile = File('${outputDir.path}/converted_document.pdf');
//     await pdfFile.writeAsBytes(await pdf.save());

//     return pdfFile;
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentHandler {
  static final DocumentHandler _instance = DocumentHandler._internal();
  factory DocumentHandler() => _instance;

  DocumentHandler._internal();

  Future<PermissionStatus> storagePermissionStatus() async {
    PermissionStatus status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    status = await Permission.storage.status;

    return status;
  }

  Future<File?> pickDocument() async {
    PermissionStatus status = await storagePermissionStatus();

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        print('Document picked: ${result.files.single.path}');
        return File(result.files.single.path!);
      } else {
        print('No document picked.');
      }
    } else {
      print('Storage permission not granted.');
    }
    return null;
  }

  Future<File?> convertDocToPdf(File docFile, String pdfName) async {
    print('Starting document conversion for: ${docFile.path}');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://192.168.0.107:5000/PDF_Maker'), // Update with your Flask server URL
    );
    request.files.add(await http.MultipartFile.fromPath('file', docFile.path));

    final response = await request.send();
    print('Server response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final Map<String, dynamic> responseBody = jsonDecode(responseData.body);

      if (responseBody.containsKey('output_path')) {
        final outputDir = await getTemporaryDirectory();
        final pdfFile = File('${outputDir.path}/$pdfName.pdf');
        await pdfFile.writeAsBytes(await responseData.bodyBytes);
        print('PDF file saved to temporary directory: ${pdfFile.path}');
        return pdfFile;
      } else {
        print('Conversion failed: ${responseBody['error']}');
        return null;
      }
    } else {
      print('Failed to convert document: ${response.statusCode}');
      return null;
    }
  }
}
