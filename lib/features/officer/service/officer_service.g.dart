// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'officer_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of documents for an application (used in officer review)

@ProviderFor(reviewDocuments)
final reviewDocumentsProvider = ReviewDocumentsFamily._();

/// Stream of documents for an application (used in officer review)

final class ReviewDocumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DocumentModel>>,
          List<DocumentModel>,
          Stream<List<DocumentModel>>
        >
    with
        $FutureModifier<List<DocumentModel>>,
        $StreamProvider<List<DocumentModel>> {
  /// Stream of documents for an application (used in officer review)
  ReviewDocumentsProvider._({
    required ReviewDocumentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reviewDocumentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reviewDocumentsHash();

  @override
  String toString() {
    return r'reviewDocumentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<DocumentModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DocumentModel>> create(Ref ref) {
    final argument = this.argument as String;
    return reviewDocuments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewDocumentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reviewDocumentsHash() => r'fdf3aab4faed2e6a6b5ef1f47ae66cda7194662a';

/// Stream of documents for an application (used in officer review)

final class ReviewDocumentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<DocumentModel>>, String> {
  ReviewDocumentsFamily._()
    : super(
        retry: null,
        name: r'reviewDocumentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Stream of documents for an application (used in officer review)

  ReviewDocumentsProvider call(String applicationId) =>
      ReviewDocumentsProvider._(argument: applicationId, from: this);

  @override
  String toString() => r'reviewDocumentsProvider';
}

/// Provides the [OfficerReviewService]

@ProviderFor(officerReviewService)
final officerReviewServiceProvider = OfficerReviewServiceProvider._();

/// Provides the [OfficerReviewService]

final class OfficerReviewServiceProvider
    extends
        $FunctionalProvider<
          OfficerReviewService,
          OfficerReviewService,
          OfficerReviewService
        >
    with $Provider<OfficerReviewService> {
  /// Provides the [OfficerReviewService]
  OfficerReviewServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'officerReviewServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$officerReviewServiceHash();

  @$internal
  @override
  $ProviderElement<OfficerReviewService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OfficerReviewService create(Ref ref) {
    return officerReviewService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OfficerReviewService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OfficerReviewService>(value),
    );
  }
}

String _$officerReviewServiceHash() =>
    r'a42e911967d5731b5e57119d8f999fddb6cfe779';
