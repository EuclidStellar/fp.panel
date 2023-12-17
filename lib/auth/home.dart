import 'package:flutter/material.dart';
import 'package:fp_panel/drawer/chaynwork/chayanartworks.dart';
import 'package:fp_panel/drawer/uploadpost.dart';
import 'package:fp_panel/registereduser/messagesend.dart';
import 'package:fp_panel/registereduser/qrscan.dart';
import 'package:fp_panel/registereduser/registreduser.dart';


class HomeScreenPage extends StatefulWidget {
  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // MembersTab(),
    UserDetailsScreen(),
    QRscan(),
    NotificationScreen(),
   // QRScannerScreen(),
    // EventsTab(),
    // ArtWorksTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaleidoscope'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Upload Artwork'),
              onTap: () {
                Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArtWorksTab()),
          ); // Close the drawer
                // Navigate to the home page if needed
              },
            ),
            ListTile(
              title: const Text('Secrets ? '),
              onTap: () {
                  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChayanWorkImages()),
          ); // Close the drawer
                // Navigate to the settings page or perform other actions
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Registered Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message Sender',
          ),
           
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle tab selection
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}


