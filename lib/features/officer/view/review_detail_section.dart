import '../../../app_exporter.dart';

/// Shows documents uploaded for a given application
class ReviewDetailSection extends ConsumerWidget {
  /// Creates the review detail section
  const ReviewDetailSection({required this.application, super.key});

  /// The application being reviewed
  final ApplicationModel application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(
      reviewDocumentsProvider(application.applicationId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReviewSectionCard(
          title: 'Personal Details',
          items: {
            'Full Name':
                '${application.firstName} ${application.middleName} ${application.lastName}'
                    .trim(),
            'Date of Birth': application.dateOfBirth != null
                ? '${application.dateOfBirth!.day}/${application.dateOfBirth!.month}/${application.dateOfBirth!.year}'
                : '-',
            'Gender': application.gender?.name ?? '-',
            'Place of Birth': application.placeOfBirth,
            'Nationality': application.nationality,
            'Occupation': application.occupation.isEmpty
                ? '-'
                : application.occupation,
          },
        ),
        const SizedBox(height: spacing12),
        ReviewSectionCard(
          title: 'Family Details',
          items: {
            "Mother's Name": application.motherName,
            "Father's Name": application.fatherName.isEmpty
                ? '-'
                : application.fatherName,
          },
        ),
        const SizedBox(height: spacing12),
        ReviewSectionCard(
          title: 'Address',
          items: {
            'Current': application.currentAddress,
            'District': application.districtOfOrigin,
            'Village': application.villageOfOrigin,
          },
        ),
        const SizedBox(height: spacing12),
        Container(
          padding: padding16,
          decoration: BoxDecoration(
            color: surfaceWhite,
            borderRadius: borderRadius8,
            border: Border.all(color: borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Supporting Documents',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: mediumGrey,
                ),
              ),
              const SizedBox(height: spacing12),
              docsAsync.when(
                data: (docs) {
                  if (docs.isEmpty) {
                    return const Text('No documents uploaded yet.');
                  }
                  return Column(
                    children: docs.map((doc) => _DocRow(doc: doc)).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, _) => const Text('Could not load documents.'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocRow extends StatelessWidget {
  const _DocRow({required this.doc});

  final DocumentModel doc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: spacing8),
      child: Row(
        children: [
          Icon(
            doc.isVerified
                ? Icons.check_circle_rounded
                : Icons.description_outlined,
            color: doc.isVerified ? successGreen : mediumGrey,
            size: iconSizeMedium,
          ),
          const SizedBox(width: spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _typeLabel(doc.documentType),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  doc.fileName.isEmpty ? 'Document' : doc.fileName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: mediumGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (doc.fileUrl.isNotEmpty)
            TextButton(
              onPressed: () {
                // Open document URL in browser / viewer
              },
              child: const Text('View'),
            ),
        ],
      ),
    );
  }

  String _typeLabel(DocumentType type) {
    switch (type) {
      case DocumentType.passportPhoto:
        return 'Passport Photo';
      case DocumentType.birthCertificate:
        return 'Birth Certificate';
      case DocumentType.previousNationalId:
        return 'Previous National ID';
      case DocumentType.schoolId:
        return 'School ID';
      case DocumentType.marriageCertificate:
        return 'Marriage Certificate';
      case DocumentType.recommendationLetter:
        return 'Recommendation Letter';
      case DocumentType.other:
        return 'Other Document';
    }
  }
}
