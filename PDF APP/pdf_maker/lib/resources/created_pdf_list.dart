import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CreatedPDF {
  final String name;
  final String path;
  final DateTime date;

  CreatedPDF({required this.name, required this.path, required this.date});

  // Convert a CreatedPDF into a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'date': date.toIso8601String(),
    };
  }

  // Convert a Map into a CreatedPDF
  factory CreatedPDF.fromJson(Map<String, dynamic> json) {
    return CreatedPDF(
      name: json['name'],
      path: json['path'],
      date: DateTime.parse(json['date']),
    );
  }
}

class CreatedPDFsList {
  static final CreatedPDFsList _singleton = CreatedPDFsList._internal();
  factory CreatedPDFsList() => _singleton;
  CreatedPDFsList._internal();

  List<CreatedPDF> createdPDFs = [];

  void addPDF(CreatedPDF pdf) {
    createdPDFs.add(pdf);
    saveToPreferences();
  }

  void removePDF(int index) {
    createdPDFs.removeAt(index);
    saveToPreferences();
  }

  void saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> pdfList =
        createdPDFs.map((pdf) => jsonEncode(pdf.toJson())).toList();
    prefs.setStringList('createdPDFs', pdfList);
  }

  void loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? pdfList = prefs.getStringList('createdPDFs');
    if (pdfList != null) {
      createdPDFs =
          pdfList.map((pdf) => CreatedPDF.fromJson(jsonDecode(pdf))).toList();
    }
  }
}
