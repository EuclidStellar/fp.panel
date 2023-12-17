


import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  List<String> scannedUsers = [];
  List<Map<String, dynamic>> fetchedUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                // Fetch user details from the 'present' collection
                fetchUsers();
              },
              icon: Icon(Icons.refresh),
            ),
          ],
          title: Text('Barcode Scanner Example'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Scanned Users'),
              Tab(text: 'Fetched Users'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Scanned Users Tab
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      // Filter scannedUsers based on the search query
                      setState(() {
                        scannedUsers = scannedUsers
                            .where((user) =>
                                user.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search by Name',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: scannedUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(scannedUsers[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Fetched Users Tab
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      // Filter fetchedUsers based on the search query
                      setState(() {
                        fetchedUsers = fetchedUsers
                            .where((user) =>
                                user['uid']
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                user['timestamp']
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search by UID or Timestamp',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: fetchedUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(fetchedUsers[index]['uid']),
                        subtitle: Text(
                          'Timestamp: ${fetchedUsers[index]['timestamp']}',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String result = await scanBarcode();
            if (result != null) {
              // Add the scanned user details to the 'present' collection
              addScannedUser(result);
              setState(() {
                scannedUsers.add(result);
              });

              // Fetch user details from the 'present' collection
              fetchUsers();
            }
          },
          tooltip: 'Scan Barcode',
          child: Icon(Icons.qr_code_scanner),
        ),
      ),
    );
  }

  Future<String> scanBarcode() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
      "#FF0000", // Color of the scanning line
      "Cancel",  // Text for the cancel button
      true,      // Show flash icon
      ScanMode.BARCODE, // Scan mode (BARCODE, QR)
    );

    return result;
  }

  Future<void> addScannedUser(String uid) async {
    try {
      // Reference to the 'present' collection
      CollectionReference presentCollection =
          FirebaseFirestore.instance.collection('present');

      // Example: Add user details to the 'present' collection
      await presentCollection.add({'uid': uid, 'timestamp': FieldValue.serverTimestamp()});
    } catch (error) {
      print('Error adding scanned user: $error');
    }
  }

  Future<void> fetchUsers() async {
    try {
      // Reference to the 'present' collection
      CollectionReference presentCollection =
          FirebaseFirestore.instance.collection('present');

      // Fetch all documents from the 'present' collection
      QuerySnapshot querySnapshot = await presentCollection.get();

      // Clear the existing fetched users list
      setState(() {
        fetchedUsers = [];
      });

      // Add each user details to the fetchedUsers list
      querySnapshot.docs.forEach((doc) {
        setState(() {
          fetchedUsers.add({
            'uid': doc['uid'],
            'timestamp': doc['timestamp'].toString(),
          });
        });
      });
    } catch (error) {
      print('Error fetching users: $error');
    }
  }
}






////// ----------------------------  working code ----------------------------//////







// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BarcodeScannerScreen extends StatefulWidget {
//   @override
//   _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
// }

// class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
//   List<String> scannedUsers = [];
//   List<Map<String, dynamic>> fetchedUsers = [];

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Barcode Scanner Example'),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Scanned Users'),
//               Tab(text: 'Fetched Users'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Scanned Users Tab
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Scanned Users:',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: scannedUsers.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(scannedUsers[index]),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             // Fetched Users Tab
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Fetched Users:',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: fetchedUsers.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(fetchedUsers[index]['uid']),
//                         subtitle: Text(
//                           'Timestamp: ${fetchedUsers[index]['timestamp']}',
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () async {
//             String result = await scanBarcode();
//             if (result != null) {
//               // Add the scanned user details to the 'present' collection
//               addScannedUser(result);
//               setState(() {
//                 scannedUsers.add(result);
//               });

//               // Fetch user details from the 'present' collection
//               fetchUsers();
//             }
//           },
//           tooltip: 'Scan Barcode',
//           child: Icon(Icons.qr_code_scanner),
//         ),
//       ),
//     );
//   }

//   Future<String> scanBarcode() async {
//     String result = await FlutterBarcodeScanner.scanBarcode(
//       "#FF0000", // Color of the scanning line
//       "Cancel",  // Text for the cancel button
//       true,      // Show flash icon
//       ScanMode.BARCODE, // Scan mode (BARCODE, QR)
//     );

//     return result;
//   }

//   Future<void> addScannedUser(String uid) async {
//     try {
//       // Reference to the 'present' collection
//       CollectionReference presentCollection =
//           FirebaseFirestore.instance.collection('present');

//       // Example: Add user details to the 'present' collection
//       await presentCollection.add({'uid': uid, 'timestamp': FieldValue.serverTimestamp()});
//     } catch (error) {
//       print('Error adding scanned user: $error');
//     }
//   }

//   Future<void> fetchUsers() async {
//     try {
//       // Reference to the 'present' collection
//       CollectionReference presentCollection =
//           FirebaseFirestore.instance.collection('present');

//       // Fetch all documents from the 'present' collection
//       QuerySnapshot querySnapshot = await presentCollection.get();

//       // Clear the existing fetched users list
//       setState(() {
//         fetchedUsers = [];
//       });

//       // Add each user details to the fetchedUsers list
//       querySnapshot.docs.forEach((doc) {
//         setState(() {
//           fetchedUsers.add({
//             'uid': doc['uid'],
//             'timestamp': doc['timestamp'].toString(),
//           });
//         });
//       });
//     } catch (error) {
//       print('Error fetching users: $error');
//     }
//   }
// }



















// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BarcodeScannerScreen extends StatefulWidget {
//   @override
//   _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
// }

// class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
//   List<String> scannedUsers = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Barcode Scanner Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Scanned Users:',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: scannedUsers.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(scannedUsers[index]),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => scanBarcode(),
//         tooltip: 'Scan Barcode',
//         child: Icon(Icons.qr_code_scanner),
//       ),
//     );
//   }

//   Future<void> scanBarcode() async {
//     String result = await FlutterBarcodeScanner.scanBarcode(
//       "#FF0000", // Color of the scanning line
//       "Cancel",  // Text for the cancel button
//       true,      // Show flash icon
//       ScanMode.BARCODE, // Scan mode (BARCODE, QR)
//     );

//     if (!mounted) return;

//     // Add the scanned user details to the 'present' collection
//     addScannedUser(result);

//     setState(() {
//       scannedUsers.add(result);
//     });
//   }

//   Future<void> addScannedUser(String uid) async {
//     try {
//       // Reference to the 'present' collection
//       CollectionReference presentCollection =
//           FirebaseFirestore.instance.collection('present');

//       // Example: Add user details to the 'present' collection
//       await presentCollection.add({'uid': uid, 'timestamp': FieldValue.serverTimestamp()});
//     } catch (error) {
//       print('Error adding scanned user: $error');
//     }
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BarcodeScannerScreen extends StatefulWidget {
//   @override
//   _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
// }

// class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
//   List<String> scannedUsers = [];
//   List<Map<String, dynamic>> fetchedUsers = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Barcode Scanner Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Scanned Users:',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: scannedUsers.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(scannedUsers[index]),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Fetched Users:',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: fetchedUsers.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(fetchedUsers[index]['uid']),
//                     subtitle: Text(
//                       'Timestamp: ${fetchedUsers[index]['timestamp']}',
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           String result = await scanBarcode();
//           if (result != null) {
//             // Add the scanned user details to the 'present' collection
//             addScannedUser(result);
//             setState(() {
//               scannedUsers.add(result);
//             });

//             // Fetch user details from the 'present' collection
//             fetchUsers();
//           }
//         },
//         tooltip: 'Scan Barcode',
//         child: Icon(Icons.qr_code_scanner),
//       ),
//     );
//   }

//   Future<String> scanBarcode() async {
//     String result = await FlutterBarcodeScanner.scanBarcode(
//       "#FF0000", // Color of the scanning line
//       "Cancel",  // Text for the cancel button
//       true,      // Show flash icon
//       ScanMode.BARCODE, // Scan mode (BARCODE, QR)
//     );

//     return result;
//   }

//   Future<void> addScannedUser(String uid) async {
//     try {
//       // Reference to the 'present' collection
//       CollectionReference presentCollection =
//           FirebaseFirestore.instance.collection('present');

//       // Example: Add user details to the 'present' collection
//       await presentCollection.add({'uid': uid, 'timestamp': FieldValue.serverTimestamp()});
//     } catch (error) {
//       print('Error adding scanned user: $error');
//     }
//   }

//   Future<void> fetchUsers() async {
//     try {
//       // Reference to the 'present' collection
//       CollectionReference presentCollection =
//           FirebaseFirestore.instance.collection('present');

//       // Fetch all documents from the 'present' collection
//       QuerySnapshot querySnapshot = await presentCollection.get();

//       // Clear the existing fetched users list
//       setState(() {
//         fetchedUsers = [];
//       });

//       // Add each user details to the fetchedUsers list
//       querySnapshot.docs.forEach((doc) {
//         setState(() {
//           fetchedUsers.add({
//             'uid': doc['uid'],
//             'timestamp': doc['timestamp'].toString(),
//           });
//         });
//       });
//     } catch (error) {
//       print('Error fetching users: $error');
//     }
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BarcodeScannerScreen extends StatefulWidget {
//   @override
//   _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
// }

// class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
//   List<String> scannedUsers = [];
//   List<Map<String, dynamic>> fetchedUsers = [];

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           actions: [
//             IconButton(
//               onPressed: () async {
//                 // Fetch user details from the 'present' collection
//                 fetchUsers();
//               },
//               icon: Icon(Icons.refresh),
//             ),
//           ],
//           title: Text('Barcode Scanner Example'),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Scanned Users'),
//               Tab(text: 'Fetched Users'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Scanned Users Tab
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Scanned Users:',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: scannedUsers.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(scannedUsers[index]),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             // Fetched Users Tab
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Fetched Users:',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: fetchedUsers.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(fetchedUsers[index]['uid']),
//                         subtitle: Text(
//                           'Timestamp: ${fetchedUsers[index]['timestamp']}',
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () async {
//             String result = await scanBarcode();
//             if (result != null) {
//               // Add the scanned user details to the 'present' collection
//               addScannedUser(result);
//               setState(() {
//                 scannedUsers.add(result);
//               });

//               // Fetch user details from the 'present' collection
//               fetchUsers();
//             }
//           },
//           tooltip: 'Scan Barcode',
//           child: Icon(Icons.qr_code_scanner),
//         ),
//       ),
//     );
//   }

//   Future<String> scanBarcode() async {
//     String result = await FlutterBarcodeScanner.scanBarcode(
//       "#FF0000", // Color of the scanning line
//       "Cancel",  // Text for the cancel button
//       true,      // Show flash icon
//       ScanMode.BARCODE, // Scan mode (BARCODE, QR)
//     );

//     return result;
//   }

//   Future<void> addScannedUser(String uid) async {
//     try {
//       // Reference to the 'present' collection
//       CollectionReference presentCollection =
//           FirebaseFirestore.instance.collection('present');

//       // Example: Add user details to the 'present' collection
//       await presentCollection.add({'uid': uid, 'timestamp': FieldValue.serverTimestamp()});
//     } catch (error) {
//       print('Error adding scanned user: $error');
//     }
//   }

//   Future<void> fetchUsers() async {
//     try {
//       // Reference to the 'present' collection
//       CollectionReference presentCollection =
//           FirebaseFirestore.instance.collection('present');

//       // Fetch all documents from the 'present' collection
//       QuerySnapshot querySnapshot = await presentCollection.get();

//       // Clear the existing fetched users list
//       setState(() {
//         fetchedUsers = [];
//       });

//       // Add each user details to the fetchedUsers list
//       querySnapshot.docs.forEach((doc) {
//         setState(() {
//           fetchedUsers.add({
//             'uid': doc['uid'],
//             'timestamp': doc['timestamp'].toString(),
//           });
//         });
//       });
//     } catch (error) {
//       print('Error fetching users: $error');
//     }
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BarcodeScannerScreen extends StatefulWidget {
//   @override
//   _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
// }

// class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
//   String barcodeScanRes = "Click the button to scan barcode";

//   Future<void> scanBarcode() async {
//     String result = await FlutterBarcodeScanner.scanBarcode(
//       "#FF0000", // Color of the scanning line
//       "Cancel",  // Text for the cancel button
//       true,      // Show flash icon
//       ScanMode.BARCODE, // Scan mode (BARCODE, QR)
//     );

//     if (!mounted) return;

//     // Add the user to the 'present' collection
//     await addPresentUser(result);

//     setState(() {
//       barcodeScanRes = result;
//     });
//   }

//   Future<void> addPresentUser(String uid) async {
//     try {
//       // Reference to the 'present' collection
//       CollectionReference presentCollection =
//           FirebaseFirestore.instance.collection('present');

//       // Example: Add user details to the 'present' collection
//       await presentCollection.add({'uid': uid});
//     } catch (error) {
//       print('Error adding present user: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Barcode Scanner Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Scanned Result:',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//             Text(
//               barcodeScanRes,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: scanBarcode,
//         tooltip: 'Scan Barcode',
//         child: Icon(Icons.qr_code_scanner),
//       ),
//     );
//   }
// }
























// --------------------------------------------//
// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// class BarcodeScannerScreen extends StatefulWidget {
//   @override
//   _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
// }

// class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
//   String barcodeScanRes = "Click the button to scan barcode";

//   Future<void> scanBarcode() async {
//     String result = await FlutterBarcodeScanner.scanBarcode(
//       "#FF0000", // Color of the scanning line
//       "Cancel",  // Text for the cancel button
//       true,      // Show flash icon
//       ScanMode.BARCODE, // Scan mode (BARCODE, QR)
//     );

//     if (!mounted) return;

//     setState(() {
//       barcodeScanRes = result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Barcode Scanner Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Scanned Result:',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//             Text(
//               barcodeScanRes,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: scanBarcode,
//         tooltip: 'Scan Barcode',
//         child: Icon(Icons.qr_code_scanner),
//       ),
//     );
//   }
// }




// working code 


// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BarcodeScannerScreen extends StatefulWidget {
//   @override
//   _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
// }

// class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
//   String barcodeScanRes = "Click the button to scan barcode";

//   Future<void> scanBarcode() async {
//     String result = await FlutterBarcodeScanner.scanBarcode(
//       "#FF0000", // Color of the scanning line
//       "Cancel",  // Text for the cancel button
//       true,      // Show flash icon
//       ScanMode.BARCODE, // Scan mode (BARCODE, QR)
//     );

//     if (!mounted) return;

//     // Check if the QR code matches any user in the qr_codes collection
//     await checkUserPresence(result);

//     setState(() {
//       barcodeScanRes = result;
//     });
//   }

//   Future<void> checkUserPresence(String uid) async {
//     try {
//       // Reference to the qr_codes collection
//       CollectionReference qrCodesCollection =
//           FirebaseFirestore.instance.collection('qr_codes');

//       // Get the document with the scanned UID
//       DocumentSnapshot qrCodeDoc = await qrCodesCollection.doc(uid).get();
//       print('qrCodeDoc: $qrCodeDoc');

//       if (qrCodeDoc.exists) {
//         // UID exists in the qr_codes collection
//         // Mark the user as present or add to the list of present users
//         markUserAsPresent(qrCodeDoc);
//       } else {
//         // UID doesn't exist in the qr_codes collection
//         // Handle accordingly (e.g., show an error message)
//         print('User not found in the qr_codes collection');
//         showUserNotFoundErrorDialog();
//       }
//     } catch (error) {
//       print('Error checking user presence: $error');
//     }
//   }

//   Future<void> markUserAsPresent(DocumentSnapshot qrCodeDoc) async {
//     try {
//       // Example: Update a 'present' field in the qr_codes collection
//       await qrCodeDoc.reference.update({'present': true});

//       // Display user details in a dialog
//       showUserDetailsDialog(qrCodeDoc);
//     } catch (error) {
//       print('Error marking user as present: $error');
//     }
//   }

//   void showUserDetailsDialog(DocumentSnapshot qrCodeDoc) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('User Details'),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('UID: ${qrCodeDoc.id}'),
//               Text('QR Data: ${qrCodeDoc['qr_data']}'),
//               // Add more user details as needed
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

//   void showUserNotFoundErrorDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('User Not Found'),
//           content: Text('User not found in the qr_codes collection.'),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Barcode Scanner Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Scanned Result:',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//             Text(
//               barcodeScanRes,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: scanBarcode,
//         tooltip: 'Scan Barcode',
//         child: Icon(Icons.qr_code_scanner),
//       ),
//     );
//   }
// }

















// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';



// class QRViewExample extends StatefulWidget {
//   const QRViewExample({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _QRViewExampleState();
// }

// class _QRViewExampleState extends State<QRViewExample> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(flex: 4, child: _buildQrView(context)),
//           Expanded(
//             flex: 1,
//             child: FittedBox(
//               fit: BoxFit.contain,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   if (result != null)
//                     Text(
//                         'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
//                   else
//                     const Text('Scan a code'),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                             onPressed: () async {
//                               await controller?.toggleFlash();
//                               setState(() {});
//                             },
//                             child: FutureBuilder(
//                               future: controller?.getFlashStatus(),
//                               builder: (context, snapshot) {
//                                 return Text('Flash: ${snapshot.data}');
//                               },
//                             )),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                             onPressed: () async {
//                               await controller?.flipCamera();
//                               setState(() {});
//                             },
//                             child: FutureBuilder(
//                               future: controller?.getCameraInfo(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.data != null) {
//                                   return Text(
//                                       'Camera facing ${describeEnum(snapshot.data!)}');
//                                 } else {
//                                   return const Text('loading');
//                                 }
//                               },
//                             )),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await controller?.pauseCamera();
//                           },
//                           child: const Text('pause',
//                               style: TextStyle(fontSize: 20)),
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await controller?.resumeCamera();
//                           },
//                           child: const Text('resume',
//                               style: TextStyle(fontSize: 20)),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 300.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: Colors.red,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }

//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('no Permission')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }






// // import 'package:flutter/material.dart';
// // import 'package:qr_code_scanner/qr_code_scanner.dart';

// // class QRScannerScreen extends StatefulWidget {
// //   @override
// //   _QRScannerScreenState createState() => _QRScannerScreenState();
// // }

// // class _QRScannerScreenState extends State<QRScannerScreen> {
// //   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
// //   late QRViewController controller;
// //   String result = '';

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('QR Code Scanner'),
// //       ),
// //       body: Column(
// //         children: <Widget>[
// //           Expanded(
// //             flex: 5,
// //             child: QRView(
// //               key: qrKey,
// //               onQRViewCreated: _onQRViewCreated,
// //             ),
// //           ),
// //           Expanded(
// //             flex: 1,
// //             child: Center(
// //               child: Text('Result: $result'),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _onQRViewCreated(QRViewController controller) {
// //     this.controller = controller;
// //     controller.scannedDataStream.listen((scanData) {
// //       setState(() {
// //         result = scanData.code!;
// //       });
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     super.dispose();
// //   }
// // }


// // import 'package:flutter/material.dart';
// // import 'package:qr_code_scanner/qr_code_scanner.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: QRViewExample(),
// //     );
// //   }
// // }

// // class QRViewExample extends StatefulWidget {
// //   @override
// //   State<StatefulWidget> createState() => _QRViewExampleState();
// // }

// // class _QRViewExampleState extends State<QRViewExample> {
// //   late QRViewController controller;
// //   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
// //   String qrText = "";

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: QRView(
// //         key: qrKey,
// //         onQRViewCreated: _onQRViewCreated,
// //       ),
// //     );
// //   }

// //   void _onQRViewCreated(QRViewController controller) {
// //     this.controller = controller;
// //     controller.scannedDataStream.listen((scanData) {
// //       setState(() {
// //         qrText = scanData.code!;
// //       });

// //       // Process the scanned QR code data (save to database, etc.)
// //       print("Scanned QR Code: $qrText");

// //       // If needed, you can stop the camera after the first scan
// //       // controller.pauseCamera();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     super.dispose();
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// class QRScan extends StatefulWidget {
//   const QRScan({super.key});

//   @override
//   State<QRScan> createState() => _QRScanState();
// }

// class _QRScanState extends State<QRScan> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Scanner'),
//       ),
//       body: const Center(
//         child: Text('QR Scanner'),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QRScan extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _QRScanState();
// }

// class _QRScanState extends State<QRScan> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   late QRViewController controller;
//   late String? scannedData ;

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Code Scanner'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: Text('Scanned Data: $scannedData'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         scannedData = scanData.code;
//       });

//       // Navigate to a different screen and pass the scanned data
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ScannedDataScreen(scannedData: scannedData!),
//         ),
//       );
//     });
//   }
// }

// class ScannedDataScreen extends StatelessWidget {
//   final String scannedData;

//   ScannedDataScreen({required this.scannedData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scanned Data'),
//       ),
//       body: Center(
//         child: Text('Scanned Data: $scannedData'),
//       ),
//     );
//   }
// }
