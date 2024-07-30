import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:pdf_maker/resources/document_handler.dart';
import 'package:pdf_maker/resources/document_list.dart';
import 'package:pdf_maker/resources/utils.dart';

class SelectedDocument extends StatefulWidget {
  const SelectedDocument({
    super.key,
  });

  @override
  _SelectedDocumentState createState() => _SelectedDocumentState();
}

class _SelectedDocumentState extends State<SelectedDocument> {
  final DocumentList documentList = DocumentList();
  late double progressValue = 0;
  late bool isExporting = false;

  Future<String?> _showPdfNameDialog(BuildContext context) async {
    final TextEditingController pdfNameController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter PDF Name'),
          content: TextField(
            controller: pdfNameController,
            decoration: const InputDecoration(hintText: 'PDF Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(pdfNameController.text);
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _convertDocument(String pdfName) async {
    setState(() {
      isExporting = true;
      progressValue = 0.0;
    });

    final DocumentHandler documentHandler = DocumentHandler();
    final File docFile = documentList.documentPaths.first;

    final pathToSave = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS);

    print('Saving PDF to path: $pathToSave');

    // Simulate conversion progress
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        progressValue = i / 100;
      });
    }

    final pdfFile = await documentHandler.convertDocToPdf(docFile, pdfName);

    if (pdfFile != null) {
      final outputFile = File('$pathToSave/$pdfName.pdf');
      await outputFile.writeAsBytes(await pdfFile.readAsBytes());

      print('PDF saved at: ${outputFile.path}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved at: ${outputFile.path}')),
      );
      MediaScanner.loadMedia(path: outputFile.path);

      setState(() {
        isExporting = false;
      });
    } else {
      setState(() {
        isExporting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to convert document')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Selected Document",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 187, 27, 16),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          color: Colors.cyan,
          textColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          onPressed: () async {
            final pdfName = await _showPdfNameDialog(context);
            if (pdfName != null && pdfName.isNotEmpty) {
              _convertDocument(pdfName);
            } else {
              Utils.flushbarmessage('Please enter a valid PDF name', context);
            }
          },
          child: const Text(
            'Convert ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: isExporting,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: LinearProgressIndicator(
                  minHeight: 15,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
                  value: progressValue,
                ),
              ),
            ),
            const Gap(10),
            Visibility(
              visible: !isExporting,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: documentList.documentPaths.length,
                itemBuilder: (BuildContext context, int index) {
                  final File file = documentList.documentPaths[index];
                  return Card(
                    child: GridTile(
                      header: const Icon(Icons.file_copy_rounded),
                      footer: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          file.path.split('/').last,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      child: const Icon(
                        Icons.file_copy_rounded,
                        size: 100,
                        color: Colors.cyan,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



  // void _convertDocument(String pdfName) async {
  //   setState(() {
  //     isExporting = true;
  //     progressValue = 0.0;
  //   });

  //   final DocumentHandler documentHandler = DocumentHandler();
  //   final File docFile = documentList.documentPaths.first;

  //   final pdfFile = await documentHandler.convertDocToPdf(docFile);

  //   if (pdfFile != null) {
  //     final pathToSave = await ExternalPath.getExternalStoragePublicDirectory(
  //         ExternalPath.DIRECTORY_DOCUMENTS);

  //     final outputFile = File('$pathToSave/$pdfName.pdf');
  //     await outputFile.writeAsBytes(await pdfFile.readAsBytes());

  //     MediaScanner.loadMedia(path: outputFile.path);

  //     setState(() {
  //       isExporting = false;
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('PDF saved at: ${outputFile.path}')),
  //     );
  //   } else {
  //     setState(() {
  //       isExporting = false;
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to convert document')),
  //     );
  //   }
  // }