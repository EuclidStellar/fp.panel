
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Literary extends StatefulWidget {
  @override
  _LiteraryState createState() => _LiteraryState();
}

class _LiteraryState extends State<Literary> {
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List<File> _selectedImages = [];
  bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImages() async {
    List<XFile>? pickedFiles = await _imagePicker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _uploadImages() async {
    String name = _nameController.text.trim();
    String description = _descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty || _selectedImages.isEmpty) {
      // Ensure all required information is available
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      for (File imageFile in _selectedImages) {
        String downloadURL = await uploadImageToFirebaseStorage(imageFile);
        await saveImageMetadataToFirestore(downloadURL, name, description);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Images uploaded successfully!'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
        _selectedImages.clear();
        _nameController.clear();
        _descriptionController.clear();
      });
    }
  }

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference =
        storage.ref().child('literary/${DateTime.now()}.png');

    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;

    // Return download URL
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> saveImageMetadataToFirestore(
    String downloadURL,
    String name,
    String description,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('literary').add({
      'name': name,
      'description': description,
      'image_url': downloadURL,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your Work'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Image Description'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickAndUploadImages,
              child: Text('Pick Images'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadImages,
              child: _isUploading ? CircularProgressIndicator() : Text('Upload Images'),
            ),
            const SizedBox(height: 16),
            _selectedImages.isNotEmpty
                ? Column(
                    children: [
                      Text('Selected Images:'),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _selectedImages.map((image) {
                          return Image.file(
                            image,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        }).toList(),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}




// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';


// class Literary extends StatefulWidget {
//   @override
//   _LiteraryState createState() => _LiteraryState();
// }

// class _LiteraryState extends State<Literary> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final ImagePicker _imagePicker = ImagePicker();
//   File? _selectedImage;

//   Future<void> _pickImage() async {
//     final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _selectedImage = File(pickedFile.path);
//       }
//     });
//   }

//   Future<void> _uploadData() async {
//     final String name = nameController.text.trim();
//     final String description = descriptionController.text.trim();

//     if (name.isNotEmpty && description.isNotEmpty && _selectedImage != null) {
//       try {
//         // Upload image to Firebase Storage
//         final Reference storageReference = FirebaseStorage.instance
//             .ref()
//             .child('literary')
//             .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
//         await storageReference.putFile(_selectedImage!);

//         // Get the URL of the uploaded image
//         final String imageUrl = await storageReference.getDownloadURL();

//         // Add data to Firestore collection
//         await FirebaseFirestore.instance.collection('literary').add({
//           'name': name,
//           'imageurl': imageUrl,
//           'description': description,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Data uploaded successfully!'),
//           ),
//         );

//         // Clear the text fields and selected image after uploading
//         nameController.clear();
//         descriptionController.clear();
//         setState(() {
//           _selectedImage = null;
//         });
//       } catch (e) {
//         print('Error uploading data: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to upload data. Please try again.'),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please enter name, description, and select an image.'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Literary Collection'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             if (_selectedImage != null)
//               Image.file(
//                 _selectedImage!,
//                 height: 100,
//                 width: 100,
//                 fit: BoxFit.cover,
//               ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: Text('Select Image'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//               maxLines: 5,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _uploadData,
//               child: Text('Upload Data'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

