import '../../../app_exporter.dart';

/// Card for a single document type with upload capability
class DocumentUploadCard extends StatelessWidget {
  /// Creates a document upload card
  const DocumentUploadCard({
    required this.documentType,
    required this.label,
    required this.description,
    required this.isRequired,
    required this.onUpload,
    this.uploadedDocument,
    this.isUploading = false,
    super.key,
  });

  /// The document type this card represents
  final DocumentType documentType;

  /// Human-readable label
  final String label;

  /// Brief description of what to upload
  final String description;

  /// Whether this document is required
  final bool isRequired;

  /// Callback triggered when the user taps upload
  final VoidCallback onUpload;

  /// The uploaded document, if any
  final DocumentModel? uploadedDocument;

  /// Whether an upload is in progress for this type
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final isUploaded = uploadedDocument != null;

    return Container(
      padding: padding16,
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: borderRadius8,
        border: Border.all(
          color: isUploaded ? successGreen : borderLight,
          width: isUploaded ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(spacing10),
            decoration: BoxDecoration(
              color: isUploaded
                  ? successGreen.withValues(alpha: 0.1)
                  : lightBlue1,
              borderRadius: borderRadius8,
            ),
            child: Icon(
              isUploaded
                  ? Icons.check_circle_rounded
                  : Icons.upload_file_rounded,
              color: isUploaded ? successGreen : facebookBlue,
              size: iconSizeLarge,
            ),
          ),
          const SizedBox(width: spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isRequired) ...[
                      const SizedBox(width: spacing4),
                      Text(
                        '*',
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(color: errorRed),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: spacing2),
                Text(
                  isUploaded ? uploadedDocument!.fileName : description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: spacing8),
          if (isUploading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            TextButton(
              onPressed: onUpload,
              child: Text(isUploaded ? 'Replace' : 'Upload'),
            ),
        ],
      ),
    );
  }
}
