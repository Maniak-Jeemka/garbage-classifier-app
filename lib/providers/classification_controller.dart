import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/classification_result.dart';
import '../presentation/home/home_provider.dart';
import 'classifier_provider.dart';

part 'classification_controller.g.dart';

@Riverpod(keepAlive: true)
class ClassificationController extends _$ClassificationController {
  @override
  FutureOr<ClassificationResult?> build() {
    return null;
  }

  Future<void> classify(File image) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(classifierProvider);
      final homeState = ref.read(homeProvider);
      return await service.classify(
        image,
        userContext: homeState.optionalContext,
      );
    });
  }
}
