import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ibp_app_ver2/screens/Appointments/appointments.dart';
import 'package:ibp_app_ver2/screens/Notifications/notifications.dart';
import 'package:ibp_app_ver2/screens/home.dart';
import 'package:ibp_app_ver2/screens/Profile/profile.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int unreadCount = 0;
  int unreadAppointmentsCount = 0;

  @override
  void initState() {
    super.initState();
    fetchUnreadCount();
  }

  Future<void> fetchUnreadCount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
    final userId = currentUser.uid;
    final memberType = 'client'; // Replace with actual memberType fetching logic if necessary

    final notificationsRef = FirebaseFirestore.instance.collection('notifications');
    final appointmentsRef = FirebaseFirestore.instance.collection('appointments');

    final unreadNotificationsSnapshot = await notificationsRef
        .where('uid', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    final memberTypeUnreadNotificationsSnapshot = await notificationsRef
        .where('member_type', isEqualTo: memberType)
        .where('read', isEqualTo: false)
        .get();

    final unreadAppointmentsSnapshot = await appointmentsRef
        .where('applicantProfile.uid', isEqualTo: userId)
        .where('appointmentDetails.read', isEqualTo: false)
        .get();

    setState(() {
      unreadCount = unreadNotificationsSnapshot.docs.length +
          memberTypeUnreadNotificationsSnapshot.docs.length;
      unreadAppointmentsCount = unreadAppointmentsSnapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: Color(0xFF580049)),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.calendar_month, color: Color(0xFF580049)),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Appointments()),
                  );
                },
              ),
              if (unreadAppointmentsCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    child: Center(
                      child: Text(
                        '$unreadAppointmentsCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Color(0xFF580049)),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Notifications()),
                  );
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    child: Center(
                      child: Text(
                        '$unreadCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.person, color: Color(0xFF580049)),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
        ],
      ),
    );
  }
}
