// document_list.dart
import 'dart:io';

class DocumentList {
  static final DocumentList _instance = DocumentList._internal();
  factory DocumentList() => _instance;

  DocumentList._internal();

  List<File> documentPaths = [];
  List<File> createdPdfs = [];

  void clearDocuments() {
    documentPaths.clear();
  }

  void addDocument(File file) {
    documentPaths.add(file);
  }

  void addCreatedPdf(File pdfFile) {
    createdPdfs.add(pdfFile);
  }

  void clearCreatedPdfs() {
    createdPdfs.clear();
  }
}
