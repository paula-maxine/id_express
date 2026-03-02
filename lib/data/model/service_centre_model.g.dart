// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_centre_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceCentreModel _$ServiceCentreModelFromJson(Map<String, dynamic> json) =>
    ServiceCentreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      district: json['district'] as String,
      address: json['address'] as String,
      operatingHours: json['operating_hours'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$ServiceCentreModelToJson(ServiceCentreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'district': instance.district,
      'address': instance.address,
      'operating_hours': instance.operatingHours,
      'is_active': instance.isActive,
    };
