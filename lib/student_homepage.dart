import 'package:class_at/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const HomePage({Key? key, required this.studentData}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.studentData['name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navigate back to login page
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(userType: 'Student'),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Info Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Information',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Student ID'),
                          subtitle: Text(widget.studentData['studentId']),
                        ),
                        ListTile(
                          leading: const Icon(Icons.school),
                          title: const Text('Course'),
                          subtitle: Text(widget.studentData['course']),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Attendance History
                Text(
                  'Attendance History',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('attendance')
                      .where('studentId',
                          isEqualTo: widget.studentData['studentId'])
                      .orderBy('timestamp', descending: true)
                      .limit(10)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No attendance records found'),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final attendance = snapshot.data!.docs[index];
                        final attendanceData =
                            attendance.data() as Map<String, dynamic>;
                        final timestamp =
                            attendanceData['timestamp'] as Timestamp;
                        final date = timestamp.toDate();

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: Text(
                                DateFormat('EEEE, MMMM d, y').format(date)),
                            subtitle: Text(DateFormat('h:mm a').format(date)),
                            trailing: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Attendance Statistics Card
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('attendance')
                      .where('studentId',
                          isEqualTo: widget.studentData['studentId'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final totalClasses =
                        50; // You should get this from your database
                    final attendedClasses = snapshot.data!.docs.length;
                    final attendancePercentage =
                        (attendedClasses / totalClasses) * 100;

                    return Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attendance Statistics',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.analytics),
                              title: const Text('Attendance Rate'),
                              subtitle: LinearProgressIndicator(
                                value: attendedClasses / totalClasses,
                                backgroundColor: Colors.grey[200],
                              ),
                              trailing: Text(
                                '${attendancePercentage.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.calendar_month),
                              title: const Text('Classes Attended'),
                              trailing: Text(
                                '$attendedClasses/$totalClasses',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
