import 'package:json_annotation/json_annotation.dart';

part 'document_model.g.dart';

@JsonSerializable()
class DocumentModel {
  final String id;
  @JsonKey(name: 'application_id')
  final String applicationId;
  final String type;
  @JsonKey(name: 'file_name')
  final String fileName;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'file_size')
  final int fileSize;
  @JsonKey(name: 'mime_type')
  final String mimeType;
  @JsonKey(name: 'uploaded_at')
  final DateTime uploadedAt;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'verified_by_uid')
  final String? verifiedByUid;
  @JsonKey(name: 'verified_at')
  final DateTime? verifiedAt;
  @JsonKey(name: 'flag_reason')
  final String? flagReason;

  DocumentModel({
    required this.id,
    required this.applicationId,
    required this.type,
    required this.fileName,
    required this.imageUrl,
    required this.fileSize,
    required this.mimeType,
    required this.uploadedAt,
    this.isVerified = false,
    this.verifiedByUid,
    this.verifiedAt,
    this.flagReason,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);

  DocumentModel copyWith({
    String? id,
    String? applicationId,
    String? type,
    String? fileName,
    String? imageUrl,
    int? fileSize,
    String? mimeType,
    DateTime? uploadedAt,
    bool? isVerified,
    String? verifiedByUid,
    DateTime? verifiedAt,
    String? flagReason,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      imageUrl: imageUrl ?? this.imageUrl,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      isVerified: isVerified ?? this.isVerified,
      verifiedByUid: verifiedByUid ?? this.verifiedByUid,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      flagReason: flagReason ?? this.flagReason,
    );
  }
}
