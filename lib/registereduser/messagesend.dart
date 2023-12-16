import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  Future<void> _addNotification() async {
    final String name = nameController.text.trim();
    final String message = messageController.text.trim();

    if (name.isNotEmpty && message.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('notification').add({
          'name': name,
          'message': message,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification added successfully!'),
          ),
        );

        // Clear the text fields after submitting
        nameController.clear();
        messageController.clear();
      } catch (e) {
        print('Error adding notification: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add notification. Please try again.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both name and message.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Anonymous Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Message'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addNotification,
              child: Text('Submit Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
