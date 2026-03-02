import 'package:json_annotation/json_annotation.dart';

part 'service_centre_model.g.dart';

@JsonSerializable()
class ServiceCentreModel {
  final String id;
  final String name;
  final String district;
  final String address;
  @JsonKey(name: 'operating_hours')
  final String operatingHours;
  @JsonKey(name: 'is_active')
  final bool isActive;

  ServiceCentreModel({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.operatingHours,
    this.isActive = true,
  });

  factory ServiceCentreModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceCentreModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceCentreModelToJson(this);

  ServiceCentreModel copyWith({
    String? id,
    String? name,
    String? district,
    String? address,
    String? operatingHours,
    bool? isActive,
  }) {
    return ServiceCentreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      address: address ?? this.address,
      operatingHours: operatingHours ?? this.operatingHours,
      isActive: isActive ?? this.isActive,
    );
  }
}
