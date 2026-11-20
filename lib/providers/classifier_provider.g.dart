// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(classifier)
final classifierProvider = ClassifierProvider._();

final class ClassifierProvider
    extends
        $FunctionalProvider<
          ClassifierService,
          ClassifierService,
          ClassifierService
        >
    with $Provider<ClassifierService> {
  ClassifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'classifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$classifierHash();

  @$internal
  @override
  $ProviderElement<ClassifierService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClassifierService create(Ref ref) {
    return classifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClassifierService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClassifierService>(value),
    );
  }
}

String _$classifierHash() => r'c3378754ed775bbc5b4228cb71108cd337d43deb';
