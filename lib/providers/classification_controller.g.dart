// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClassificationController)
final classificationControllerProvider = ClassificationControllerProvider._();

final class ClassificationControllerProvider
    extends
        $AsyncNotifierProvider<
          ClassificationController,
          ClassificationResult?
        > {
  ClassificationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'classificationControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$classificationControllerHash();

  @$internal
  @override
  ClassificationController create() => ClassificationController();
}

String _$classificationControllerHash() =>
    r'fcb03186dd6508715c18dfad66301ec789c9e603';

abstract class _$ClassificationController
    extends $AsyncNotifier<ClassificationResult?> {
  FutureOr<ClassificationResult?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<ClassificationResult?>, ClassificationResult?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ClassificationResult?>,
                ClassificationResult?
              >,
              AsyncValue<ClassificationResult?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
