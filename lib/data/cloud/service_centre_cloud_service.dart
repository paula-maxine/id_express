import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/service_centre_model.dart';
import 'app_exception.dart';

class ServiceCentreCloudService {
  final FirebaseFirestore _firestore;

  ServiceCentreCloudService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get all service centres
  Future<List<ServiceCentreModel>> getAllCentres() async {
    try {
      final query = await _firestore
          .collection('service_centres')
          .where('is_active', isEqualTo: true)
          .get();
      return query.docs
          .map((doc) => ServiceCentreModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch service centres: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch service centres: $e',
        originalException: e,
      );
    }
  }

  /// Get service centres by district
  Future<List<ServiceCentreModel>> getCentresByDistrict(String district) async {
    try {
      final query = await _firestore
          .collection('service_centres')
          .where('district', isEqualTo: district)
          .where('is_active', isEqualTo: true)
          .get();
      return query.docs
          .map((doc) => ServiceCentreModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch service centres by district: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch service centres by district: $e',
        originalException: e,
      );
    }
  }

  /// Get service centre by ID
  Future<ServiceCentreModel?> getCentre(String id) async {
    try {
      final doc =
          await _firestore.collection('service_centres').doc(id).get();
      if (!doc.exists) return null;
      return ServiceCentreModel.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch service centre: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch service centre: $e',
        originalException: e,
      );
    }
  }

  /// Stream all active service centres
  Stream<List<ServiceCentreModel>> streamAllCentres() {
    try {
      return _firestore
          .collection('service_centres')
          .where('is_active', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ServiceCentreModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to stream service centres: $e',
        originalException: e,
      );
    }
  }
}
