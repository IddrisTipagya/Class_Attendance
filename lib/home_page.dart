import 'package:flutter/material.dart';
import 'login_page.dart'; // Import your login page file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Attendance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen height to calculate spacing
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight =
        screenHeight - kToolbarHeight - MediaQuery.of(context).padding.top;
    final spacingBetweenCards =
        availableHeight * 0.08; // Reduced spacing between cards

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: const Text(
          'Select user type',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/university_logo.jpeg',
            height: 70,
            width: 70,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              constraints: BoxConstraints(maxWidth: 800),
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: spacingBetweenCards * 0.5,
                  horizontal: 16,
                ),
                children: [
                  UserTypeCard(
                    imagePath: 'assets/images/Student.jpeg',
                    userType: 'Student',
                    description:
                        'Access your attendance records and class schedule',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage(userType: 'Student'),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: spacingBetweenCards),
                  UserTypeCard(
                    imagePath: 'assets/images/lecturer.jpeg',
                    userType: 'Lecturer',
                    description: 'Manage classes and track student attendance',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage(userType: 'Lecturer'),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: spacingBetweenCards),
                  UserTypeCard(
                    imagePath: 'assets/images/teaching_assistant.jpeg',
                    userType: 'Teaching Assistant',
                    description:
                        'Assist with attendance tracking and class management',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage(userType: 'Teaching Assistant'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class UserTypeCard extends StatelessWidget {
  final String imagePath;
  final String userType;
  final String description;
  final VoidCallback onPressed;

  const UserTypeCard({
    Key? key,
    required this.imagePath,
    required this.userType,
    required this.description,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 160, // Increased height
        decoration: BoxDecoration(
          color: const Color(0xFFD2B48C).withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          border:
              Border.all(color: Colors.lightBlue.withOpacity(0.7), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image Container
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(15)),
              child: SizedBox(
                width: 160, // Increased width to match height
                height: 160, // Increased height
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Text Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userType,
                      style: const TextStyle(
                        fontSize: 24, // Increased font size
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8), // Increased spacing
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 15, // Increased font size
                        color: Colors.black87.withOpacity(0.8),
                      ),
                      maxLines: 3, // Increased max lines
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Arrow Icon
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue,
                size: 24, // Increased icon size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
