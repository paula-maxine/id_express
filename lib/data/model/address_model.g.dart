// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
  district: json['district'] as String,
  county: json['county'] as String,
  subCounty: json['sub_county'] as String,
  parish: json['parish'] as String,
  village: json['village'] as String,
);

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'district': instance.district,
      'county': instance.county,
      'sub_county': instance.subCounty,
      'parish': instance.parish,
      'village': instance.village,
    };
