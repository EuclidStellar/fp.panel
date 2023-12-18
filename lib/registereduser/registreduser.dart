

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserDetailsScreen extends StatefulWidget {
//   @override
//   _UserDetailsScreenState createState() => _UserDetailsScreenState();
// }

// class _UserDetailsScreenState extends State<UserDetailsScreen> {
//   TextEditingController searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Details'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search by Name',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.clear),
//                   onPressed: () {
//                     searchController.clear();
//                     // You can reload the full list here if needed
//                   },
//                 ),
//               ),
//               onChanged: (value) {
//                 // You can filter the list based on the search query here
//                 // Example: users.where((user) => user.name.contains(value)).toList();
//                 setState(() {});
//               },
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance.collection('chayan24').snapshots(),
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
//                     child: Text('No user data available.'),
//                   );
//                 }

//                 // Map each document to a User object
//                 List<User> users = snapshot.data!.docs.map((doc) {
//                   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//                   return User(
//                     name: data['name'] ?? '',
//                     email: data['email'] ?? '',
//                     class1: data['class'] ?? '',
//                     section: data['section'] ?? '',
//                     branch: data['branch'] ?? '',
//                     driveLink: data['driveLink'] ?? '',
//                     year: data['year'] ?? '',
//                     phone: data['phone'] ?? '',
//                   );
//                 }).toList();

//                 // Filter users based on the search query
//                 String searchQuery = searchController.text.toLowerCase();
//                 List<User> filteredUsers = users
//                     .where((user) => user.name.toLowerCase().contains(searchQuery))
//                     .toList();

//                 // Display the user details using Card
//                 return ListView.builder(
//                   itemCount: filteredUsers.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       elevation: 5,
//                       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                       child: ListTile(
//                         title: Text(filteredUsers[index].name),
//                         subtitle: Text(
//                           'Email: ${filteredUsers[index].email}\nClass: ${filteredUsers[index].class1}\nYear: ${filteredUsers[index].year}',
//                         ),
//                         // Add more details as needed
//                         onTap: () {
//                           _showUserDetailsDialog(context, filteredUsers[index]);
//                         },
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

//   void _showUserDetailsDialog(BuildContext context, User user) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(user.name),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Email: ${user.email}'),
//               Text('Class: ${user.class1}'),
//               Text('Section: ${user.section}'),
//               Text('Branch: ${user.branch}'),
//               Text('Drive Link: ${user.driveLink}'),
//               Text('Year: ${user.year}'),
//               Text('Phone: ${user.phone}')
//               // Add more details as needed
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
// }

// class User {
//   final String name;
//   final String email;
//   final String class1;
//   final String section;
//   final String branch;
//   final String driveLink;
//   final String year;
//   final String phone; // Change the type to String if 'year' is stored as a String

//   User({
//     required this.name,
//     required this.phone,
//     required this.email,
//     required this.class1,
//     required this.section,
//     required this.branch,
//     required this.driveLink,
//     required this.year,
//   });
// }










// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // class UserDetailsScreen extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('User Details'),
// // //       ),
// // //       body: StreamBuilder(
// // //         stream: FirebaseFirestore.instance.collection('chayan24').snapshots(),
// // //         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return Center(
// // //               child: CircularProgressIndicator(),
// // //             );
// // //           }

// // //           if (snapshot.hasError) {
// // //             return Center(
// // //               child: Text('Error: ${snapshot.error}'),
// // //             );
// // //           }

// // //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// // //             return Center(
// // //               child: Text('No user data available.'),
// // //             );
// // //           }

// // //           // Map each document to a User object
// // //           List<User> users = snapshot.data!.docs.map((doc) {
// // //             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
// // //             return User(
// // //               name: data['name'] ?? '',
// // //               email: data['email'] ?? '',
// // //               class1: data['class'] ?? '',
// // //               section: data['section'] ?? '',
// // //               branch: data['branch'] ?? '',
// // //               driveLink: data['driveLink'] ?? '',
// // //               year: data['year'] ?? 0,
// // //             );
// // //           }).toList();

// // //           // Display the user details
// // //           return ListView.builder(
// // //             itemCount: users.length,
// // //             itemBuilder: (context, index) {
// // //               return ListTile(
// // //                 title: Text(users[index].name),
// // //                 subtitle: Text('Email: ${users[index].email}\nClass: ${users[index].class1}\nYear: ${users[index].year}'),
// // //                 // Add more details as needed
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // // class User {
// // //   final String name;
// // //   final String email;
// // //   final String class1;
// // //   final String section;
// // //   final String branch;
// // //   final String driveLink;
// // //   final String year; // Change the type to String if 'year' is stored as a String

// // //   User({
// // //     required this.name,
// // //     required this.email,
// // //     required this.class1,
// // //     required this.section,
// // //     required this.branch,
// // //     required this.driveLink,
// // //     required this.year,
// // //   });
// // // }


// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class UserDetailsScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('User Details'),
// //       ),
// //       body: StreamBuilder(
// //         stream: FirebaseFirestore.instance.collection('chayan24').snapshots(),
// //         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(
// //               child: CircularProgressIndicator(),
// //             );
// //           }

// //           if (snapshot.hasError) {
// //             return Center(
// //               child: Text('Error: ${snapshot.error}'),
// //             );
// //           }

// //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //             return Center(
// //               child: Text('No user data available.'),
// //             );
// //           }

// //           // Map each document to a User object
// //           List<User> users = snapshot.data!.docs.map((doc) {
// //             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
// //             return User(
// //               name: data['name'] ?? '',
// //               email: data['email'] ?? '',
// //               class1: data['class'] ?? '',
// //               section: data['section'] ?? '',
// //               branch: data['branch'] ?? '',
// //               driveLink: data['driveLink'] ?? '',
// //               year: data['year'] ?? '',
// //               phone:data['phone'] ?? '',
// //             );
// //           }).toList();

// //           // Display the user details
// //           return ListView.builder(
// //             itemCount: users.length,
// //             itemBuilder: (context, index) {
// //               return ListTile(
// //                 title: Text(users[index].name),
// //                 subtitle: Text('Email: ${users[index].email}\nClass: ${users[index].class1}\nYear: ${users[index].year}'),
// //                 // Add more details as needed
// //                 onTap: () {
// //                   _showUserDetailsDialog(context, users[index]);
// //                 },
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   void _showUserDetailsDialog(BuildContext context, User user) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text(user.name),
// //           content: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text('Email: ${user.email}'),
// //               Text('Class: ${user.class1}'),
// //               Text('Section: ${user.section}'),
// //               Text('Branch: ${user.branch}'),
// //               Text('Drive Link: ${user.driveLink}'),
// //               Text('Year: ${user.year}'),
// //               Text('Phone: ${user.phone}')
// //               // Add more details as needed
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //               child: Text('Close'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }

// // class User {
// //   final String name;
// //   final String email;
// //   final String class1;
// //   final String section;
// //   final String branch;
// //   final String driveLink;
// //   final String year;
// //   final String phone ;// Change the type to String if 'year' is stored as a String

// //   User({
// //     required this.name,
// //     required this.phone,
// //     required this.email,
// //     required this.class1,
// //     required this.section,
// //     required this.branch,
// //     required this.driveLink,
// //     required this.year,
// //   });
// // }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserDetailsScreen extends StatefulWidget {
//   @override
//   _UserDetailsScreenState createState() => _UserDetailsScreenState();
// }

// class _UserDetailsScreenState extends State<UserDetailsScreen> {
//   TextEditingController searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Details'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search by Name',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.clear),
//                   onPressed: () {
//                     searchController.clear();
//                     // You can reload the full list here if needed
//                   },
//                 ),
//               ),
//               onChanged: (value) {
//                 // You can filter the list based on the search query here
//                 // Example: users.where((user) => user.name.contains(value)).toList();
//                 setState(() {});
//               },
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance.collection('chayan24').snapshots(),
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
//                     child: Text('No user data available.'),
//                   );
//                 }

//                 // Map each document to a User object
//                 List<User> users = snapshot.data!.docs.map((doc) {
//                   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//                   return User(
//                     name: data['name'] ?? '',
//                     email: data['email'] ?? '',
//                     class1: data['class'] ?? '',
//                     section: data['section'] ?? '',
//                     branch: data['branch'] ?? '',
//                     driveLink: data['driveLink'] ?? '',
//                     year: data['year'] ?? '',
//                     phone: data['phone'] ?? '',
//                   );
//                 }).toList();

//                 // Filter users based on the search query
//                 String searchQuery = searchController.text.toLowerCase();
//                 List<User> filteredUsers = users
//                     .where((user) => user.name.toLowerCase().contains(searchQuery))
//                     .toList();

//                 // Display the user details
//                 return ListView.builder(
//                   itemCount: filteredUsers.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(filteredUsers[index].name),
//                       subtitle: Text(
//                           'Email: ${filteredUsers[index].email}\nClass: ${filteredUsers[index].class1}\nYear: ${filteredUsers[index].year}'),
//                       // Add more details as needed
//                       onTap: () {
//                         _showUserDetailsDialog(context, filteredUsers[index]);
//                       },
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

//   void _showUserDetailsDialog(BuildContext context, User user) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(user.name),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Email: ${user.email}'),
//               Text('Class: ${user.class1}'),
//               Text('Section: ${user.section}'),
//               Text('Branch: ${user.branch}'),
//               Text('Drive Link: ${user.driveLink}'),
//               Text('Year: ${user.year}'),
//               Text('Phone: ${user.phone}')
//               // Add more details as needed
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
// }

// class User {
//   final String name;
//   final String email;
//   final String class1;
//   final String section;
//   final String branch;
//   final String driveLink;
//   final String year;
//   final String phone; // Change the type to String if 'year' is stored as a String

//   User({
//     required this.name,
//     required this.phone,
//     required this.email,
//     required this.class1,
//     required this.section,
//     required this.branch,
//     required this.driveLink,
//     required this.year,
//   });
// }




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('User Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    // You can reload the full list here if needed
                  },
                ),
              ),
              onChanged: (value) {
                // You can filter the list based on the search query here
                // Example: users.where((user) => user.name.contains(value)).toList();
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('chayan24').snapshots(),
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
                    child: Text('No user data available.'),
                  );
                }

                // Map each document to a User object
                List<User> users = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  return User(
                    name: data['name'] ?? '',
                    email: data['email'] ?? '',
                    class1: data['class'] ?? '',
                    section: data['section'] ?? '',
                    branch: data['branch'] ?? '',
                    driveLink: data['driveLink'] ?? '',
                    year: data['year'] ?? '',
                    phone: data['phone'] ?? '',
                  );
                }).toList();

                // Filter users based on the search query
                String searchQuery = searchController.text.toLowerCase();
                List<User> filteredUsers = users
                    .where((user) => user.name.toLowerCase().contains(searchQuery))
                    .toList();

                // Display the user details using Card
                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(filteredUsers[index].name),
                        subtitle: Text(
                          'Email: ${filteredUsers[index].email}\nClass: ${filteredUsers[index].class1}\nYear: ${filteredUsers[index].year}',
                        ),
                        // Add more details as needed
                        onTap: () {
                          _showUserDetailsDialog(context, filteredUsers[index]);
                        },
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

  void _showUserDetailsDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(user.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: ${user.email}'),
              Text('Class: ${user.class1}'),
              Text('Section: ${user.section}'),
              Text('Branch: ${user.branch}'),
              Text('Drive Link: ${user.driveLink}'),
              Text('Year: ${user.year}'),
              Text('Phone: ${user.phone}')
              // Add more details as needed
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
}

class User {
  final String name;
  final String email;
  final String class1;
  final String section;
  final String branch;
  final String driveLink;
  final String year;
  final String phone; // Change the type to String if 'year' is stored as a String

  User({
    required this.name,
    required this.phone,
    required this.email,
    required this.class1,
    required this.section,
    required this.branch,
    required this.driveLink,
    required this.year,
  });
}
