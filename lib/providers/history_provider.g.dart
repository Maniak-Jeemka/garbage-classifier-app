// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(History)
final historyProvider = HistoryProvider._();

final class HistoryProvider
    extends $AsyncNotifierProvider<History, List<ScanRecord>> {
  HistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyHash();

  @$internal
  @override
  History create() => History();
}

String _$historyHash() => r'86adfb97f38485c88de42fcc755825717f595fa7';

abstract class _$History extends $AsyncNotifier<List<ScanRecord>> {
  FutureOr<List<ScanRecord>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ScanRecord>>, List<ScanRecord>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ScanRecord>>, List<ScanRecord>>,
              AsyncValue<List<ScanRecord>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
