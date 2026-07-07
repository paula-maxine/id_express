import '../../../app_exporter.dart';

/// Screen for uploading supporting documents for an application
class DocumentsScreen extends ConsumerStatefulWidget {
  /// Creates the documents screen
  const DocumentsScreen({required this.applicationId, super.key});

  /// The application to upload documents for
  final String applicationId;

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  DocumentType? _activeUpload;
  final _picker = ImagePicker();

  static const _requiredDocs = [
    (
      type: DocumentType.passportPhoto,
      label: 'Passport Photo',
      description: 'Clear face photo, white background',
      required: true,
    ),
    (
      type: DocumentType.birthCertificate,
      label: 'Birth Certificate',
      description: 'Certified copy of birth certificate',
      required: true,
    ),
    (
      type: DocumentType.previousNationalId,
      label: 'Previous National ID',
      description: 'Required for renewal or replacement',
      required: false,
    ),
    (
      type: DocumentType.schoolId,
      label: 'School ID / Letter',
      description: 'School identification for students',
      required: false,
    ),
    (
      type: DocumentType.marriageCertificate,
      label: 'Marriage Certificate',
      description: 'Required for married applicants',
      required: false,
    ),
    (
      type: DocumentType.recommendationLetter,
      label: 'Recommendation Letter',
      description: 'Local council recommendation',
      required: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final docsAsync = ref.watch(
      applicationDocumentsProvider(widget.applicationId),
    );
    final progress = ref.watch(uploadProgressProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Upload Documents'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          if (progress != null) ...[
            LinearProgressIndicator(
              value: progress,
              backgroundColor: lightGrey,
              color: facebookBlue,
              minHeight: 3,
            ),
          ],
          Expanded(
            child: docsAsync.when(
              data: (docs) {
                final uploaded = {for (final d in docs) d.documentType: d};

                return ListView.separated(
                  padding: const EdgeInsets.all(spacing16),
                  itemCount: _requiredDocs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: spacing12),
                  itemBuilder: (_, i) {
                    final spec = _requiredDocs[i];
                    return DocumentUploadCard(
                      documentType: spec.type,
                      label: spec.label,
                      description: spec.description,
                      isRequired: spec.required,
                      uploadedDocument: uploaded[spec.type],
                      isUploading: _activeUpload == spec.type,
                      onUpload: () => _pickAndUpload(spec.type),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUpload(DocumentType type) async {
    final isPhoto = type == DocumentType.passportPhoto;
    final XFile? file;

    if (isPhoto) {
      file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
    } else {
      // For non-photo docs let user pick from camera or gallery
      file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
    }

    if (file == null || !mounted) return;

    setState(() => _activeUpload = type);
    try {
      await ref
          .read(documentServiceProvider)
          .uploadDocument(
            applicationId: widget.applicationId,
            documentType: type,
            filePath: file.path,
            fileName: file.name,
          );
    } catch (e, s) {
      Printer.error(
        'Document upload failed',
        tag: 'Documents',
        error: e,
        stackTrace: s,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _activeUpload = null);
    }
  }
}
