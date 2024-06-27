import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ibp_app_ver2/navbar.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          NotificationsList(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const CustomNavigationBar(),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationsList extends StatefulWidget {
  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  @override
  void initState() {
    super.initState();
    _markAllAsRead();
  }

  Future<void> _markAllAsRead() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final notificationsRef =
          FirebaseFirestore.instance.collection('notifications');

      final unreadNotificationsSnapshot = await notificationsRef
          .where('uid', isEqualTo: userId)
          .where('read', isEqualTo: false)
          .get();

      for (var doc in unreadNotificationsSnapshot.docs) {
        await doc.reference.update({'read': true});
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return [];
    }
    final userId = currentUser.uid;
    final memberType = 'client';

    final notificationsRef =
        FirebaseFirestore.instance.collection('notifications');

    final userNotificationsSnapshot = await notificationsRef
        .where('uid', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    final memberTypeNotificationsSnapshot = await notificationsRef
        .where('member_type', isEqualTo: memberType)
        .orderBy('timestamp', descending: true)
        .get();

    final notificationsData = [
      ...userNotificationsSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()}),
      ...memberTypeNotificationsSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()}),
    ];

    notificationsData.sort((a, b) =>
        (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp));

    return notificationsData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final notifications = snapshot.data ?? [];

        if (notifications.isEmpty) {
          return Center(child: Text('No notifications'));
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            IconData icon;
            switch (notification['type']) {
              case 'appointment':
                icon = Icons.calendar_today;
                break;
              case 'profile_update':
                icon = Icons.edit;
                break;
              default:
                icon = Icons.mail;
            }
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: notification['read'] ? Colors.white : Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                boxShadow: notification['read']
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                border: Border.all(
                  color: notification['read'] ? Colors.grey[300]! : Colors.blue,
                  width: 1,
                ),
              ),
              child: ListTile(
                leading: Icon(icon, color: Colors.blue),
                title: Text(
                  notification['message'],
                  style: TextStyle(
                    fontWeight: notification['read']
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd – kk:mm').format(
                      (notification['timestamp'] as Timestamp).toDate()),
                ),
                trailing: notification['read']
                    ? null
                    : Icon(Icons.circle, color: Colors.red, size: 12),
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(notification['id'])
                      .update({'read': true});
                  setState(() {
                    notification['read'] =
                        true; // Update the state locally for immediate UI feedback
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Notifications(),
  ));
}
