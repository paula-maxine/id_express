import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/appointment_model.dart';
import 'app_exception.dart';

class AppointmentCloudService {
  final FirebaseFirestore _firestore;

  AppointmentCloudService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create an appointment
  Future<AppointmentModel> createAppointment(
      AppointmentModel appointment) async {
    try {
      final docRef = _firestore.collection('appointments').doc();
      final appointmentWithId = appointment.copyWith(id: docRef.id);
      await docRef.set(appointmentWithId.toJson());
      return appointmentWithId;
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to create appointment: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to create appointment: $e',
        originalException: e,
      );
    }
  }

  /// Get appointments by applicant UID
  Future<List<AppointmentModel>> getAppointmentsByApplicant(String uid) async {
    try {
      final query = await _firestore
          .collection('appointments')
          .where('applicant_uid', isEqualTo: uid)
          .orderBy('date_time', descending: false)
          .get();
      return query.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch appointments: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch appointments: $e',
        originalException: e,
      );
    }
  }

  /// Stream appointments by applicant UID
  Stream<List<AppointmentModel>> streamAppointmentsByApplicant(String uid) {
    try {
      return _firestore
          .collection('appointments')
          .where('applicant_uid', isEqualTo: uid)
          .orderBy('date_time', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => AppointmentModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to stream appointments: $e',
        originalException: e,
      );
    }
  }

  /// Get appointments by date and service centre
  Future<List<AppointmentModel>> getAppointmentsByDate(
      String centreId, DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final query = await _firestore
          .collection('appointments')
          .where('service_centre_id', isEqualTo: centreId)
          .where('date_time', isGreaterThanOrEqualTo: startOfDay)
          .where('date_time', isLessThan: endOfDay)
          .orderBy('date_time', descending: false)
          .get();

      return query.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch appointments by date: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch appointments by date: $e',
        originalException: e,
      );
    }
  }

  /// Cancel appointment
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'cancelled'});
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to cancel appointment: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to cancel appointment: $e',
        originalException: e,
      );
    }
  }

  /// Reschedule appointment
  Future<void> rescheduleAppointment(
      String appointmentId, DateTime newDateTime) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'date_time': newDateTime});
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to reschedule appointment: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to reschedule appointment: $e',
        originalException: e,
      );
    }
  }
}
