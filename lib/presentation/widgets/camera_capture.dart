import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'clay.dart';

class CameraCapture extends StatefulWidget {
  const CameraCapture({
    super.key,
    required this.onCaptured,
    required this.onGallery,
  });

  final ValueChanged<XFile> onCaptured;
  final VoidCallback onGallery;

  @override
  State<CameraCapture> createState() => _CameraCaptureState();
}

class _CameraCaptureState extends State<CameraCapture>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _lifecycleFuture;
  bool _failed = false;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _lifecycleFuture = _stop();
    } else if (state == AppLifecycleState.resumed) {
      _lifecycleFuture = _restart();
    }
  }

  Future<void> _restart() async {
    final pending = _lifecycleFuture;
    if (pending != null) {
      try {
        await pending;
      } catch (_) {}
    }
    await _start();
  }

  Future<void> _start() async {
    if (_controller != null) return;
    setState(() => _failed = false);
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('noCamera', 'Tidak ada kamera');
      }
      final back = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted || _controller != null) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } on CameraException {
      if (mounted) setState(() => _failed = true);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _stop() async {
    final controller = _controller;
    if (controller == null) return;
    setState(() => _controller = null);
    await controller.dispose();
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || _capturing) return;
    setState(() => _capturing = true);
    try {
      widget.onCaptured(await controller.takePicture());
    } on CameraException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengambil foto. Coba lagi.')),
        );
      }
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = _controller != null && !_capturing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClaySurface(
          depth: 1.15,
          child: AspectRatio(aspectRatio: 3 / 4, child: _buildViewport()),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClayCircleButton(
              icon: Icons.photo_library_rounded,
              tooltip: 'Pilih dari galeri',
              onPressed: widget.onGallery,
            ),
            ClayCircleButton(
              icon: Icons.photo_camera_rounded,
              tooltip: 'Ambil foto',
              size: 84,
              iconSize: 34,
              accent: true,
              onPressed: ready ? _capture : null,
            ),
            const SizedBox(width: 56, height: 56),
          ],
        ),
      ],
    );
  }

  Widget _buildViewport() {
    final controller = _controller;
    if (_failed) return _CameraMessage(onRetry: _start);
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final size = controller.value.previewSize!;
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.height,
        height: size.width,
        child: CameraPreview(controller),
      ),
    );
  }
}

class _CameraMessage extends StatelessWidget {
  const _CameraMessage({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Kamera tidak bisa dibuka',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Izinkan akses kamera di pengaturan ponsel, lalu coba lagi. '
            'Atau pilih foto dari galeri.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          ClayButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
