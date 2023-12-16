
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Art extends StatefulWidget {
  @override
  _ArtState createState() => _ArtState();
}

class _ArtState extends State<Art> {
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
        storage.ref().child('art/${DateTime.now()}.png');

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

    await firestore.collection('art').add({
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
