// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentCameraScreen extends StatefulWidget {
  final String title; // e.g.  "Capture Driving Licence (Back Side)"
  final String hintText; // e.g.  "Driving Licence (Back Side)"
  final Function(File? file) onImageCaptured;

  const DocumentCameraScreen({
    super.key,
    required this.title,
    required this.hintText,
    required this.onImageCaptured,
  });

  @override
  State<DocumentCameraScreen> createState() => _DocumentCameraScreenState();
}

class _DocumentCameraScreenState extends State<DocumentCameraScreen> {
  late CameraController _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    // pick first rear camera
    final rear = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back);
    _controller = CameraController(rear, ResolutionPreset.medium, enableAudio: false);
    await _controller.initialize();
    if (mounted) setState(() => _isReady = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ---  bottom sheet to pick from gallery  ---
  Future<void> _pickFromGallery() async {
    final XFile? pic = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pic != null) widget.onImageCaptured(File(pic.path));
  }

  // ---  take photo  ---
  Future<void> _capture() async {
    final XFile pic = await _controller.takePicture();
    widget.onImageCaptured(File(pic.path));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: _isReady
            ? Column(
                children: [
                  // ----------  TOP BAR ----------
                  Container(
                    color: Colors.white,
                    height: kToolbarHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),

                  // ----------  CAMERA PREVIEW with overlay ----------
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final height = constraints.maxHeight;
                        final boxWidth = width * 0.85;
                        final boxHeight = boxWidth * (54 / 86); // Maintain Aadhaar/License ratio
                        final verticalOffset = (height - boxHeight) / 2;
                        final horizontalOffset = (width - boxWidth) / 2;

                        return Stack(
                          children: [
                            CameraPreview(_controller),

                            // Top overlay
                            Positioned(
                              left: 0,
                              top: 0,
                              right: 0,
                              height: verticalOffset,
                              child: Container(color: Colors.black.withOpacity(0.6)),
                            ),

                            // Bottom overlay
                            Positioned(
                              left: 0,
                              bottom: 0,
                              right: 0,
                              height: verticalOffset,
                              child: Container(color: Colors.black.withOpacity(0.6)),
                            ),

                            // Left overlay
                            Positioned(
                              left: 0,
                              top: verticalOffset,
                              width: horizontalOffset,
                              height: boxHeight,
                              child: Container(color: Colors.black.withOpacity(0.6)),
                            ),

                            // Right overlay
                            Positioned(
                              right: 0,
                              top: verticalOffset,
                              width: horizontalOffset,
                              height: boxHeight,
                              child: Container(color: Colors.black.withOpacity(0.6)),
                            ),

                            // Yellow corner border box
                            Positioned(
                              top: verticalOffset,
                              left: horizontalOffset,
                              width: boxWidth,
                              height: boxHeight,
                              child: CustomPaint(painter: _CornerBorderPainter()),
                            ),

                            // Hint text
                            Positioned(
                              top: verticalOffset + boxHeight + 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  widget.hintText,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // ----------  BOTTOM BAR ----------
                  Container(
                    height: size.width * 0.215,
                    color: Colors.black87,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // gallery
                        IconButton(
                          icon: Icon(
                            Icons.photo_library,
                            color: Colors.white70,
                            size: size.width * 0.0704,
                          ),
                          onPressed: _pickFromGallery,
                        ),
                        // shutter
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
                        SizedBox(width: size.width * 0.109), // spacer (for symmetry)
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

// -----------------------------------------------------------------
// Orange corner rectangle painter
// -----------------------------------------------------------------
class _CornerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double len = 18;
    const double stroke = 3;
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;

    // top‑left
    canvas.drawLine(Offset(0, 0), Offset(len, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, len), paint);

    // top‑right
    canvas.drawLine(Offset(size.width - len, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), paint);

    // bottom‑left
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - len), paint);
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), paint);

    // bottom‑right
    canvas.drawLine(Offset(size.width, size.height - len), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width - len, size.height), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
