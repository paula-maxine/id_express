import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/service_centre_model.dart';
import 'service_providers.dart';

// All service centres provider
final serviceCentresProvider =
    FutureProvider<List<ServiceCentreModel>>((ref) async {
  final centreService = ref.watch(serviceCentreCloudServiceProvider);
  return centreService.getAllCentres();
});

// Stream service centres
final serviceCentresStreamProvider =
    StreamProvider<List<ServiceCentreModel>>((ref) {
  final centreService = ref.watch(serviceCentreCloudServiceProvider);
  return centreService.streamAllCentres();
});

// Service centres by district
final serviceCentresByDistrictProvider =
    FutureProvider.family<List<ServiceCentreModel>, String>(
  (ref, district) async {
    final centreService = ref.watch(serviceCentreCloudServiceProvider);
    return centreService.getCentresByDistrict(district);
  },
);

// Single service centre provider
final serviceCentreProvider =
    FutureProvider.family<ServiceCentreModel?, String>((ref, centreId) async {
  final centreService = ref.watch(serviceCentreCloudServiceProvider);
  return centreService.getCentre(centreId);
});
