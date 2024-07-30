import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_maker/resources/images_list.dart';
import 'package:pdf_maker/resources/reuseable_dialog.dart';
import 'package:pdf_maker/resources/round_button.dart';
import 'package:pdf_maker/resources/utils.dart';
import 'package:pdf_maker/view/selected_images.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotToPdf extends StatefulWidget {
  const PhotToPdf({super.key});

  @override
  State<PhotToPdf> createState() => _PhotToPdfState();
}

class _PhotToPdfState extends State<PhotToPdf> {
  bool imagesSelected = false;
  final ImagesList imagesList = ImagesList(); // Access the singleton instance

  Future<PermissionStatus> storagePermissionStatus() async {
    PermissionStatus storagePermissionStatus = await Permission.storage.status;

    if (!storagePermissionStatus.isGranted) {
      await Permission.storage.request();
    }

    storagePermissionStatus = await Permission.storage.status;

    return storagePermissionStatus;
  }

  Future<PermissionStatus> cameraPermissionStatus() async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;

    if (!cameraPermissionStatus.isGranted) {
      await Permission.camera.request();
    }

    cameraPermissionStatus = await Permission.camera.status;

    return cameraPermissionStatus;
  }

  Future<void> pickGalleryImage() async {
    PermissionStatus status = await storagePermissionStatus();

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        imagesList.clearimages();
        imagesList.imagespaths.addAll(images);
        setState(() {
          imagesSelected = true;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PhotToPdf(),
          ),
        );
      } else {
        setState(() {
          imagesSelected = false;
        });
      }
    }
  }

  Future<void> captureCameraImages() async {
    PermissionStatus status = await cameraPermissionStatus();

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        imagesList.clearimages();
        imagesList.imagespaths.add(image);
        setState(() {
          imagesSelected = true;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PhotToPdf(),
          ),
        );
      } else {
        setState(() {
          imagesSelected = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (imagesList.imagespaths.isNotEmpty) {
      imagesSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 187, 27, 16),
        title: const Text(
          'Photo to PDF',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showPhotoSourceDialog(
                          context, pickGalleryImage, captureCameraImages);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      minimumSize: const Size(160, 50),
                    ),
                    child: const Text(
                      'SELECT PHOTOS',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (imagesSelected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SelectedImages(imagesList: imagesList),
                        ),
                      );
                      Utils.flushbarmessage("Images are selected", context);
                    } else {
                      Utils.flushbarmessage("No images selected", context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: imagesSelected ? Colors.cyan : Colors.grey,
                    minimumSize: const Size(160, 50),
                  ),
                  child: const Text(
                    'MAKE PDF',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Utility Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: <Widget>[
                UtilityButton(
                  icon: Icons.lock,
                  label: 'Add Pass',
                  onpressed: () {
                    if (imagesSelected) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ReusableDialog(
                            title: 'Enter Pass',
                            content: PasswordContent(
                              onPasswordEntered: (String password) {
                                // Handle the password (e.g., save it for PDF protection)
                                print("Password entered: $password");
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Trigger the password entered callback
                                  // This is handled in the PasswordContent widget
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Utils.flushbarmessage("No images selected", context);
                    }
                  },
                ),
                UtilityButton(
                  icon: Icons.edit,
                  label: 'Edit Photos',
                  onpressed: () {},
                ),
                UtilityButton(
                  icon: Icons.compress,
                  label: 'Compress 29%',
                  onpressed: () {},
                ),
                UtilityButton(
                  icon: Icons.border_all,
                  label: 'Border: 0',
                  onpressed: () {},
                ),
                UtilityButton(
                  icon: Icons.image,
                  label: 'Grayscale',
                  onpressed: () {},
                ),
                UtilityButton(
                  icon: Icons.margin,
                  label: 'Margin',
                  onpressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showPhotoSourceDialog(
    BuildContext context,
    Future<void> Function() pickGalleryImage,
    Future<void> Function() captureCameraImages) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
            child: Text(
          'Select photos source',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: pickGalleryImage,
                  child: const Text('GALLERY'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: captureCameraImages,
                  child: const Text('CAMERA'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
