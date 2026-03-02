import 'package:uuid/uuid.dart';

String generateTrackingRef() {
  // Simple unique reference using UUID v4
  return const Uuid().v4();
}
