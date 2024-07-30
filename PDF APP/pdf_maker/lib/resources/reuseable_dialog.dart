// import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'images_list.dart';

class ReusableDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  ReusableDialog({
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
    );
  }
}

class PasswordContent extends StatefulWidget {
  final Function(String) onPasswordEntered;

  PasswordContent({required this.onPasswordEntered});

  @override
  _PasswordContentState createState() => _PasswordContentState();
}

class _PasswordContentState extends State<PasswordContent> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(hintText: "Password"),
          obscureText: true,
        ),
      ],
    );
  }
}

// Future<void> cropImage(int index) async {
//   final ImagesList imagesList = ImagesList();
//   String imagePath = imagesList.imagespaths[index].path;

//   CroppedFile? croppedFile = await ImageCropper().cropImage(
//     sourcePath: imagePath,
//     uiSettings: [
//       AndroidUiSettings(
//         toolbarTitle: 'Crop Image',
//         toolbarColor: Colors.cyan,
//         toolbarWidgetColor: Colors.white,
//         initAspectRatio: CropAspectRatioPreset.original,
//         lockAspectRatio: false,
//       ),
//       IOSUiSettings(
//         minimumAspectRatio: 1.0,
//       ),
//     ],
//     aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0), // example aspect ratio
//     aspectRatioPresets: Platform.isAndroid
//         ? [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio16x9
//           ]
//         : [
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio5x3,
//             CropAspectRatioPreset.ratio5x4,
//             CropAspectRatioPreset.ratio7x5,
//             CropAspectRatioPreset.ratio16x9
//           ],
//   );

//   if (croppedFile != null) {
//     // Update the image path with the cropped image
//     XFile croppedXFile = XFile(croppedFile.path);
//     imagesList.updateImage(index, croppedXFile);
//     print("Cropped image path: ${croppedFile.path}");
//   }
// }