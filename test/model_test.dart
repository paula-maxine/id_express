import 'package:flutter_test/flutter_test.dart';
import 'package:id_express/data/model/address_model.dart';
import 'package:id_express/data/model/application_model.dart';

void main() {
  test('ApplicationModel JSON serialization roundtrip', () {
    final app = ApplicationModel(
      id: '123',
      applicantUid: 'uid',
      trackingRef: 'track',
      fullName: 'Test',
      dateOfBirth: DateTime(2000, 1, 1),
      gender: 'M',
      nationality: 'X',
      address: AddressModel(
        district: 'D',
        county: 'C',
        subCounty: 'S',
        parish: 'P',
        village: 'V',
      ),
      parentGuardianName: null,
      parentGuardianId: null,
      status: 'submitted',
      documentIds: ['doc1'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final json = app.toJson();
    final decoded = ApplicationModel.fromJson(json);
    expect(decoded.id, app.id);
    expect(decoded.applicantUid, app.applicantUid);
    expect(decoded.address.district, app.address.district);
  });
}