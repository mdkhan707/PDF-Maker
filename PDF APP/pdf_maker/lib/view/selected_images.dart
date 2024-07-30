import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;
import 'package:pdf_maker/Routes/routes_name.dart';
import 'package:pdf_maker/resources/created_pdf_list.dart';
import 'package:pdf_maker/resources/images_list.dart';
import 'package:pdf_maker/resources/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectedImages extends StatefulWidget {
  final ImagesList imagesList;
  const SelectedImages({super.key, required this.imagesList});

  @override
  State<SelectedImages> createState() => _SelectedImagesState();
}

class _SelectedImagesState extends State<SelectedImages> {
  ImagesList imagesList = ImagesList();
  late double progressValue = 0;
  late bool isExporting = false;
  late int convertedImage = 0;

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

  void convertImage(String pdfName) async {
    setState(() {
      isExporting = true;
    });

    // Request storage permission
    PermissionStatus storagePermissionStatus = await Permission.storage.status;
    if (!storagePermissionStatus.isGranted) {
      await Permission.storage.request();
      storagePermissionStatus = await Permission.storage.status;
    }

    if (!storagePermissionStatus.isGranted) {
      Utils.flushbarmessage('Storage permission denied', context);
      return;
    }

    // Get the path to save the PDF
    final pathToSave = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS);

    // Ensure the directory exists
    final directory = Directory(pathToSave);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final pdf = pw.Document();

    for (final imagePath in imagesList.imagespaths) {
      final imageBytes = await File(imagePath.path).readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image != null) {
        final pdfImage = pw.MemoryImage(imageBytes);
        pdf.addPage(
          pw.Page(build: (pw.Context context) {
            return pw.Center(child: pw.Image(pdfImage));
          }),
        );
      }

      setState(() {
        convertedImage++;
        progressValue = convertedImage / imagesList.imagespaths.length;
      });
    }

    // Save the PDF
    final outputFile = File('$pathToSave/$pdfName.pdf');
    await outputFile.writeAsBytes(await pdf.save());

    // Add the created PDF to the list
    CreatedPDFsList().addPDF(CreatedPDF(
      name: pdfName,
      path: outputFile.path,
      date: DateTime.now(),
    ));

    // Debugging print statement
    print('Added PDF: $pdfName at path: ${outputFile.path}');
    print('Current PDFs in list: ${CreatedPDFsList().createdPDFs}');

    // Update the media scanner
    MediaScanner.loadMedia(path: outputFile.path);

    setState(() {
      isExporting = false;
    });

    // Show a SnackBar with the save location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved at: ${outputFile.path}')),
    );

    // Navigate to the home screen
    Navigator.pushReplacementNamed(context, RoutesName.homescreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Selected Images",
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
              convertImage(pdfName);
            } else {
              Utils.flushbarmessage('Please enter a valid PDF name', context);
            }
          },
          child: const Text(
            'Convert',
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
                itemCount: imagesList.imagespaths.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Image(
                      image: FileImage(
                        File(imagesList.imagespaths[index].path),
                      ),
                      fit: BoxFit.contain,
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
