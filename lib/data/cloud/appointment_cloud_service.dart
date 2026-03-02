import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../model/appointment_model.dart';
import '../model/audit_log_model.dart';
import '../model/service_centre_model.dart';
import 'app_exception.dart';
import 'audit_cloud_service.dart';

class AppointmentCloudService {
  final FirebaseFirestore _firestore;

  AppointmentCloudService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create an appointment
  Future<AppointmentModel> createAppointment(
      AppointmentModel appointment) async {
    try {
      // Ensure queue token exists; generate if empty
      String queueToken = appointment.queueToken;
      if (queueToken.isEmpty) {
        queueToken = await _generateQueueTokenForCentre(
            appointment.serviceCentreId, appointment.dateTime);
      }

      final docRef = _firestore.collection('appointments').doc();
      final appointmentWithId = appointment.copyWith(
        id: docRef.id,
        queueToken: queueToken,
      );
      await docRef.set(appointmentWithId.toJson());

      // Audit log
      try {
        final auditSvc = AuditCloudService(firestore: _firestore);
        final audit = AuditLogModel(
          id: const Uuid().v4(),
          userId: appointmentWithId.applicantUid,
          userRole: 'applicant',
          action: 'appointment_created',
          targetCollection: 'appointments',
          targetDocId: appointmentWithId.id,
          details: {
            'service_centre': appointmentWithId.serviceCentreId,
            'date_time': appointmentWithId.dateTime.toIso8601String(),
            'queue_token': appointmentWithId.queueToken,
          },
          timestamp: DateTime.now(),
        );
        await auditSvc.logAction(audit);
      } catch (_) {}

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

  /// Generate a queue token for a service centre on a specific date.
  /// Format: {centreCode}-{YYYYMMDD}-{4-digit sequence}
  Future<String> _generateQueueTokenForCentre(
      String centreId, DateTime date) async {
    try {
      // Load centre to get code
      final centreDoc = await _firestore.collection('service_centres').doc(centreId).get();
      final centre = centreDoc.exists
          ? ServiceCentreModel.fromJson(centreDoc.data() as Map<String, dynamic>)
          : ServiceCentreModel(
              id: centreId,
              code: 'CEN',
              name: 'Unknown',
              district: 'Unknown',
              address: '',
              operatingHours: '',
            );

      final centreCode = centre.code.toUpperCase();

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final query = await _firestore
          .collection('appointments')
          .where('service_centre_id', isEqualTo: centreId)
          .where('date_time', isGreaterThanOrEqualTo: startOfDay)
          .where('date_time', isLessThan: endOfDay)
          .get();

      int maxSeq = 0;
      for (final doc in query.docs) {
        final data = doc.data();
        final token = data['queue_token'] as String? ?? '';
        final parts = token.split('-');
        if (parts.length >= 3) {
          final seqPart = parts.last;
          final seq = int.tryParse(seqPart) ?? 0;
          if (seq > maxSeq) maxSeq = seq;
        }
      }

      final nextSeq = maxSeq + 1;
      final datePart = '${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
      final seqStr = nextSeq.toString().padLeft(4, '0');
      return '$centreCode-$datePart-$seqStr';
    } catch (e) {
      // Fallback token
      final datePart = '${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
      return 'CEN-$datePart-0001';
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

  /// Get appointments for a given date (all centres)
  Future<List<AppointmentModel>> getAppointmentsForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final query = await _firestore
          .collection('appointments')
          .where('date_time', isGreaterThanOrEqualTo: startOfDay)
          .where('date_time', isLessThan: endOfDay)
          .orderBy('date_time', descending: false)
          .get();

      return query.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch appointments for date: $e',
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
