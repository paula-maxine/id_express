import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app_exporter.dart';

part 'appointment_service.g.dart';

/// Service for booking and managing appointments
class AppointmentService {
  /// Creates the appointment service
  const AppointmentService(this.ref);

  /// Riverpod ref
  final Ref ref;

  /// Books a new appointment
  Future<AppointmentModel> bookAppointment({
    required String applicationId,
    required ApplicationType serviceType,
    required String centerId,
    required String centerName,
    required String centerAddress,
    required DateTime appointmentDate,
    required String timeSlot,
  }) async {
    final uid = ref.read(userIdProvider);
    if (uid == null || uid.isEmpty) {
      throw Exception('User not authenticated');
    }

    // Generate queue number (center prefix + date + sequence)
    final dateStr =
        '${appointmentDate.year}${appointmentDate.month.toString().padLeft(2, '0')}${appointmentDate.day.toString().padLeft(2, '0')}';
    final queueNumber =
        '${centerId.substring(0, 3).toUpperCase()}-$dateStr-${const Uuid().v4().substring(0, 4).toUpperCase()}';

    final appointmentId = const Uuid().v4();

    final appointment = AppointmentModel(
      appointmentId: appointmentId,
      applicationId: applicationId,
      applicantId: uid,
      serviceType: serviceType,
      centerId: centerId,
      centerName: centerName,
      centerAddress: centerAddress,
      appointmentDate: appointmentDate,
      timeSlot: timeSlot,
      queueNumber: queueNumber,
      status: AppointmentStatus.confirmed,
      createdAt: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .set(appointment.toMap());

    return appointment;
  }

  /// Cancels an existing appointment
  Future<void> cancelAppointment(String appointmentId) async {
    await _setStatus(appointmentId, AppointmentStatus.cancelled);
  }

  /// Marks an appointment as completed (done). Used by officers/admins.
  Future<void> markAsDone(String appointmentId) async {
    await _setStatus(appointmentId, AppointmentStatus.completed);
  }

  Future<void> _setStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .update({
          'status': status.name,
          'is_cancelled': status == AppointmentStatus.cancelled,
          'is_completed': status == AppointmentStatus.completed,
          'updated_at': DateTime.now().toIso8601String(),
        });
  }

  /// Sweeps the given appointments and marks any confirmed-but-passed ones as
  /// overdue in Firestore. Runs when an appointments page is visited (by the
  /// applicant or any staff member). Returns the number updated.
  Future<int> sweepOverdue(List<AppointmentModel> appointments) async {
    final due = appointments
        .where((a) => a.status == AppointmentStatus.confirmed && a.isOverdue)
        .toList();
    if (due.isEmpty) return 0;

    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();
    for (final a in due) {
      batch.update(
        firestore.collection('appointments').doc(a.appointmentId),
        {
          'status': AppointmentStatus.overdue.name,
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
    }
    await batch.commit();
    return due.length;
  }
}

/// Provides the [AppointmentService]
@Riverpod(keepAlive: true)
AppointmentService appointmentService(Ref ref) => AppointmentService(ref);

/// Stream of appointments for the current user
@riverpod
Stream<List<AppointmentModel>> userAppointments(Ref ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null || uid.isEmpty) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('appointments')
      .where('applicant_id', isEqualTo: uid)
      .orderBy('appointment_date', descending: true)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => AppointmentModel.fromMap(d.data())).toList(),
      );
}

/// Stream of all appointments (for officer/admin management)
@riverpod
Stream<List<AppointmentModel>> allAppointments(Ref ref) {
  return FirebaseFirestore.instance
      .collection('appointments')
      .orderBy('appointment_date', descending: true)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => AppointmentModel.fromMap(d.data())).toList(),
      );
}

/// Selected appointment center
@Riverpod(keepAlive: true)
class SelectedCenter extends _$SelectedCenter {
  @override
  ({String id, String name, String address})? build() => null;

  /// Updates the selected center
  void set(String id, String name, String address) =>
      state = (id: id, name: name, address: address);

  /// Clears the selection
  void clear() => state = null;
}

/// Selected appointment date
@Riverpod(keepAlive: true)
class AppointmentDate extends _$AppointmentDate {
  @override
  DateTime? build() => null;

  /// Updates the date
  void set(DateTime v) => state = v;

  /// Clears the date
  void clear() => state = null;
}

/// Selected time slot
@Riverpod(keepAlive: true)
class SelectedTimeSlot extends _$SelectedTimeSlot {
  @override
  String build() => '';

  /// Updates the slot
  void update(String v) => state = v;

  /// Clears the slot
  void clear() => state = '';
}

/// Whether booking is in progress
@Riverpod(keepAlive: true)
class BookingLoading extends _$BookingLoading {
  @override
  bool build() => false;

  void set(bool v) => state = v;
}

/// Booking error message
@Riverpod(keepAlive: true)
class BookingError extends _$BookingError {
  @override
  String build() => '';

  void set(String v) => state = v;
  void clear() => state = '';
}
