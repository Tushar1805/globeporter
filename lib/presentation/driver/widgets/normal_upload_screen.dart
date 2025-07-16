import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SelfieCameraScreen extends StatefulWidget {
  final Function(File file) onImageCaptured;
  final String title;

  const SelfieCameraScreen({
    super.key,
    required this.onImageCaptured,
    this.title = 'Capture Photo',
  });

  @override
  State<SelfieCameraScreen> createState() => _SelfieCameraScreenState();
}

class _SelfieCameraScreenState extends State<SelfieCameraScreen> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  bool _isReady = false;
  bool _isRearCamera = false; // start with front camera for selfie
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _startCamera(_isRearCamera ? _getRearCamera() : _getFrontCamera());
  }

  CameraDescription _getRearCamera() =>
      _cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back);

  CameraDescription _getFrontCamera() =>
      _cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);

  Future<void> _startCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.medium, enableAudio: false);
    await _controller.initialize();
    if (mounted) {
      setState(() => _isReady = true);
    }
  }

  void _switchCamera() {
    setState(() {
      _isRearCamera = !_isRearCamera;
      _isReady = false;
    });
    _startCamera(_isRearCamera ? _getRearCamera() : _getFrontCamera());
  }

  Future<void> _capture() async {
    final XFile pic = await _controller.takePicture();
    _storeImage(File(pic.path));
  }

  Future<void> _pickFromGallery() async {
    final XFile? pic = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pic != null) _storeImage(File(pic.path));
  }

  void _storeImage(File file) {
    setState(() {
      _capturedImage = file;
    });
    widget.onImageCaptured(file);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isReady
            ? Column(
                children: [
                  // Top Bar (same style as DocumentCameraScreen)
                  Container(
                    color: Colors.white,
                    height: kToolbarHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Spacer(),

                        // Switch Camera
                        IconButton(
                          icon: const Icon(Icons.cameraswitch, color: primaryColor),
                          iconSize: size.width * 0.07,
                          onPressed: _switchCamera,
                        ),
                      ],
                    ),
                  ),

                  // Camera Preview
                  Expanded(
                    child: CameraPreview(_controller),
                  ),

                  // Bottom Controls
                  Container(
                    height: size.width * 0.215,
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Upload from Gallery
                        IconButton(
                          icon: const Icon(Icons.photo_library, color: Colors.white70),
                          iconSize: size.width * 0.07,
                          onPressed: _pickFromGallery,
                        ),

                        // Capture Button
                        GestureDetector(
                          onTap: _capture,
                          child: Container(
                            width: size.width * 0.14,
                            height: size.width * 0.14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                          ),
                        ),

                        // Preview Thumbnail
                        if (_capturedImage != null)
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                fullImagePreviewScreen,
                                extra: {'imageFile': _capturedImage},
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                _capturedImage!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 60, height: 60),
                      ],
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
