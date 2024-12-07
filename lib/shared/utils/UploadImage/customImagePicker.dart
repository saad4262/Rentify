//
// import 'dart:io';
// import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
//
// class ImagePickerScreen extends StatefulWidget {
//   @override
//   _ImagePickerScreenState createState() => _ImagePickerScreenState();
// }
//
// class _ImagePickerScreenState extends State<ImagePickerScreen> {
//   File? _selectedImage;
//
//   Future<void> _pickImageFromGallery() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Image Picker')),
//       body: Center(
//         child: _selectedImage != null
//             ? CircleAvatar(
//           radius: 60,
//           backgroundImage: FileImage(_selectedImage!),
//         )
//             : GestureDetector(
//           onTap: _pickImageFromGallery,
//           child: Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 2),
//             ),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.grey[200],
//                 ),
//                 Icon(
//                   Icons.camera_alt_outlined,
//                   color: Colors.grey,
//                   size: 30,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
