// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [DocumentService]

@ProviderFor(documentService)
final documentServiceProvider = DocumentServiceProvider._();

/// Provides the [DocumentService]

final class DocumentServiceProvider
    extends
        $FunctionalProvider<DocumentService, DocumentService, DocumentService>
    with $Provider<DocumentService> {
  /// Provides the [DocumentService]
  DocumentServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentServiceHash();

  @$internal
  @override
  $ProviderElement<DocumentService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentService create(Ref ref) {
    return documentService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentService>(value),
    );
  }
}

String _$documentServiceHash() => r'a4e0828c0c76e725781305b4d73c107800b99914';

/// Stream of documents for a given application

@ProviderFor(applicationDocuments)
final applicationDocumentsProvider = ApplicationDocumentsFamily._();

/// Stream of documents for a given application

final class ApplicationDocumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DocumentModel>>,
          List<DocumentModel>,
          Stream<List<DocumentModel>>
        >
    with
        $FutureModifier<List<DocumentModel>>,
        $StreamProvider<List<DocumentModel>> {
  /// Stream of documents for a given application
  ApplicationDocumentsProvider._({
    required ApplicationDocumentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'applicationDocumentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$applicationDocumentsHash();

  @override
  String toString() {
    return r'applicationDocumentsProvider'
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
    return applicationDocuments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApplicationDocumentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$applicationDocumentsHash() =>
    r'cc53aae8c9ae648cd80166398b41c070ed9256cb';

/// Stream of documents for a given application

final class ApplicationDocumentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<DocumentModel>>, String> {
  ApplicationDocumentsFamily._()
    : super(
        retry: null,
        name: r'applicationDocumentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Stream of documents for a given application

  ApplicationDocumentsProvider call(String applicationId) =>
      ApplicationDocumentsProvider._(argument: applicationId, from: this);

  @override
  String toString() => r'applicationDocumentsProvider';
}

/// Upload progress state (0.0 to 1.0, or null when idle)

@ProviderFor(UploadProgress)
final uploadProgressProvider = UploadProgressProvider._();

/// Upload progress state (0.0 to 1.0, or null when idle)
final class UploadProgressProvider
    extends $NotifierProvider<UploadProgress, double?> {
  /// Upload progress state (0.0 to 1.0, or null when idle)
  UploadProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadProgressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadProgressHash();

  @$internal
  @override
  UploadProgress create() => UploadProgress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double?>(value),
    );
  }
}

String _$uploadProgressHash() => r'048c2a5b18cd804a8a4397d347d217510e56605b';

/// Upload progress state (0.0 to 1.0, or null when idle)

abstract class _$UploadProgress extends $Notifier<double?> {
  double? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<double?, double?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double?, double?>,
              double?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
