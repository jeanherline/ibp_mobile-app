import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ibp_app_ver2/navbar.dart';
import 'package:ibp_app_ver2/screens/Appointments/appointmentDetails.dart';

class Appointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          AppointmentsList(),
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

class AppointmentsList extends StatefulWidget {
  @override
  _AppointmentsListState createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<AppointmentsList> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return [];
    }
    final userId = currentUser.uid;

    final appointmentsRef =
        FirebaseFirestore.instance.collection('appointments');

    final appointmentsSnapshot = await appointmentsRef
        .where('applicantProfile.uid', isEqualTo: userId)
        .orderBy('appointmentDetails.createdDate', descending: true)
        .get();

    return appointmentsSnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final appointments = snapshot.data ?? [];

        if (appointments.isEmpty) {
          return Center(child: Text('No appointments'));
        }

        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            final controlNumber =
                appointment['appointmentDetails']['controlNumber'];
            final createdDate =
                (appointment['appointmentDetails']['createdDate'] as Timestamp)
                    .toDate();
            final appointmentStatus =
                appointment['appointmentDetails']['appointmentStatus'];
            final appointmentDate =
                appointment['appointmentDetails']['appointmentDate'] != null
                    ? (appointment['appointmentDetails']['appointmentDate']
                            as Timestamp)
                        .toDate()
                    : null;
            final read =
                appointment['read'] ?? false; // Provide a default value

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: read ? Colors.white : Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: read ? Colors.grey[300]! : Colors.blue,
                  width: 1,
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.blue),
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                          text: 'TICKET #',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: controlNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                              ' is currently ${capitalizeFirstLetter(appointmentStatus)}'),
                      if (appointmentDate != null)
                        TextSpan(
                          text:
                              '. Scheduled appointment is at ${DateFormat('MMMM dd, yyyy \'at\' hh:mm a').format(appointmentDate)}',
                        ),
                    ],
                  ),
                ),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd – kk:mm').format(createdDate),
                ),
                trailing: read
                    ? null
                    : Icon(Icons.circle, color: Colors.red, size: 12),
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('appointments')
                      .doc(controlNumber) // Use controlNumber as document ID
                      .update({'read': true});
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentDetails(
                        controlNumber: controlNumber,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  String capitalizeFirstLetter(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}

void main() {
  runApp(MaterialApp(
    home: Appointments(),
  ));
}
