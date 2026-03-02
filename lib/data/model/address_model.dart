import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  final String district;
  final String county;
  @JsonKey(name: 'sub_county')
  final String subCounty;
  final String parish;
  final String village;

  AddressModel({
    required this.district,
    required this.county,
    required this.subCounty,
    required this.parish,
    required this.village,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  AddressModel copyWith({
    String? district,
    String? county,
    String? subCounty,
    String? parish,
    String? village,
  }) {
    return AddressModel(
      district: district ?? this.district,
      county: county ?? this.county,
      subCounty: subCounty ?? this.subCounty,
      parish: parish ?? this.parish,
      village: village ?? this.village,
    );
  }
}
