// doc_to_pdf.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf_maker/resources/document_handler.dart';
import 'package:pdf_maker/resources/document_list.dart';
import 'package:pdf_maker/view/selectedDocument.dart';

class DocToPdf extends StatefulWidget {
  const DocToPdf({super.key});

  @override
  State<DocToPdf> createState() => _DocToPdfState();
}

class _DocToPdfState extends State<DocToPdf> {
  final DocumentHandler docHandler = DocumentHandler();
  final DocumentList documentList = DocumentList();

  void _selectDocument() async {
    File? docFile = await docHandler.pickDocument();

    if (docFile != null) {
      documentList.clearDocuments();
      documentList.addDocument(docFile);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SelectedDocument(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No document selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 187, 27, 16),
        title: const Text(
          'Doc to PDF',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _selectDocument,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan,
            minimumSize: const Size(160, 50),
          ),
          child: const Text(
            'SELECT DOCUMENT',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
