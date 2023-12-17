

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChayanWorkImages extends StatefulWidget {
  @override
  _ChayanWorkImagesState createState() => _ChayanWorkImagesState();
}

class _ChayanWorkImagesState extends State<ChayanWorkImages> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChayanWork Images'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _searchImages(value);
              },
              decoration: InputDecoration(
                hintText: 'Search by name',
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chayanwork')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No image data available.'),
                  );
                }

                List<ImageData> images = snapshot.data!.docs
                    .map((doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      return ImageData(
                        name: data['name'] ?? '',
                        email: data['email'] ?? '',
                        phone: data['phone'] ?? '',
                        description: data['description'] ?? '',
                        imageUrl: data['image_url'] ?? '',
                      );
                    })
                    .where((image) =>
                        image.name.toLowerCase().contains(_searchController.text.toLowerCase()))
                    .toList();

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _showImageDetailsDialog(context, images[index]);
                      },
                      child: Image.network(
                        images[index].imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDetailsDialog(BuildContext context, ImageData imageData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(imageData.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: ${imageData.email}'),
              Text('Phone: ${imageData.phone}'),
              Text('Description: ${imageData.description}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _showFullScreenImage(context, imageData.imageUrl);
                },
                child: Text('Show Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  void _searchImages(String searchTerm) {
    // Perform search based on the entered term, you can update the stream accordingly.
    // For simplicity, this example just rebuilds the entire widget.
    setState(() {});
  }
}

class ImageData {
  final String name;
  final String email;
  final String phone;
  final String description;
  final String imageUrl;

  ImageData({
    required this.name,
    required this.email,
    required this.phone,
    required this.description,
    required this.imageUrl,
  });
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChayanWorkImages extends StatefulWidget {
//   @override
//   _ChayanWorkImagesState createState() => _ChayanWorkImagesState();
// }

// class _ChayanWorkImagesState extends State<ChayanWorkImages> {
//   late TextEditingController _searchController;

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ChayanWork Images'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               _searchImages(_searchController.text);
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search by name',
//               ),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('chayanwork')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Error: ${snapshot.error}'),
//                   );
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(
//                     child: Text('No image data available.'),
//                   );
//                 }

//                 List<ImageData> images = snapshot.data!.docs
//                     .map((doc) {
//                       Map<String, dynamic> data =
//                           doc.data() as Map<String, dynamic>;
//                       return ImageData(
//                         name: data['name'] ?? '',
//                         email: data['email'] ?? '',
//                         phone: data['phone'] ?? '',
//                         description: data['description'] ?? '',
//                         imageUrl: data['image_url'] ?? '',
//                       );
//                     })
//                     .where((image) =>
//                         image.name.toLowerCase().contains(_searchController.text.toLowerCase()))
//                     .toList();

//                 return GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 8.0,
//                     mainAxisSpacing: 8.0,
//                   ),
//                   itemCount: images.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         _showImageDetailsDialog(context, images[index]);
//                       },
//                       child: Image.network(
//                         images[index].imageUrl,
//                         fit: BoxFit.cover,
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showImageDetailsDialog(BuildContext context, ImageData imageData) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(imageData.name),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Email: ${imageData.email}'),
//               Text('Phone: ${imageData.phone}'),
//               Text('Description: ${imageData.description}'),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   _showFullScreenImage(context, imageData.imageUrl);
//                 },
//                 child: Text('Show Image'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showFullScreenImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(imageUrl),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _searchImages(String searchTerm) {
//     // Perform search based on the entered term, you can update the stream accordingly.
//     // For simplicity, this example just rebuilds the entire widget.
//     setState(() {});
//   }
// }

// class ImageData {
//   final String name;
//   final String email;
//   final String phone;
//   final String description;
//   final String imageUrl;

//   ImageData({
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.description,
//     required this.imageUrl,
//   });
// }
