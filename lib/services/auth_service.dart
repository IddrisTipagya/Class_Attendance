import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Student login with ID and PIN
  Future<Map<String, dynamic>?> studentLogin(
      String studentId, String pin) async {
    try {
      // Query Firestore for the student
      QuerySnapshot student = await _firestore
          .collection('students')
          .where('studentId', isEqualTo: studentId)
          .where('pin', isEqualTo: pin)
          .get();

      if (student.docs.isEmpty) {
        throw Exception('Invalid student ID or PIN');
      }

      // Return student data if found
      return {
        ...student.docs.first.data() as Map<String, dynamic>,
        'id': student.docs.first.id, // Include the document ID
      };
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Get student by ID
  Future<Map<String, dynamic>?> getStudentById(String studentId) async {
    try {
      QuerySnapshot student = await _firestore
          .collection('students')
          .where('studentId', isEqualTo: studentId)
          .get();

      if (student.docs.isEmpty) {
        return null;
      }

      return student.docs.first.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get student: $e');
    }
  }

  // Validate student PIN
  Future<bool> validatePin(String studentId, String pin) async {
    try {
      QuerySnapshot student = await _firestore
          .collection('students')
          .where('studentId', isEqualTo: studentId)
          .where('pin', isEqualTo: pin)
          .get();

      return student.docs.isNotEmpty;
    } catch (e) {
      throw Exception('PIN validation failed: $e');
    }
  }
}
