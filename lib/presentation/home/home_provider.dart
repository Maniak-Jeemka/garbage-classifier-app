import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'home_provider.g.dart';

class HomeState {
  final XFile? image;
  final String optionalContext;
  final bool isLoading;

  HomeState({
    this.image,
    this.optionalContext = '',
    this.isLoading = false,
  });

  HomeState copyWith({
    XFile? image,
    bool clearImage = false,
    String? optionalContext,
    bool? isLoading,
  }) {
    return HomeState(
      image: clearImage ? null : (image ?? this.image),
      optionalContext: optionalContext ?? this.optionalContext,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class Home extends _$Home {
  @override
  HomeState build() => HomeState();

  final _picker = ImagePicker();

  Future<void> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state = state.copyWith(image: image);
    }
  }

  Future<void> takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      state = state.copyWith(image: image);
    }
  }

  void setContext(String text) {
    state = state.copyWith(optionalContext: text);
  }

  void clearImage() {
    state = state.copyWith(clearImage: true);
  }
}
