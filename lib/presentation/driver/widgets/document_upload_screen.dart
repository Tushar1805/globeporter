// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class DocumentCameraScreen extends StatefulWidget {
  final String title;
  final String hintText;
  final String type; // aadhaar, pan, licence, rc, other
  final Function(File? file, bool? front) onImageCaptured;
  final bool? front;

  const DocumentCameraScreen({
    super.key,
    required this.title,
    required this.hintText,
    required this.type,
    required this.onImageCaptured,
    this.front,
  });

  @override
  State<DocumentCameraScreen> createState() => _DocumentCameraScreenState();
}

class _DocumentCameraScreenState extends State<DocumentCameraScreen> {
  late CameraController _controller;
  bool _isReady = false;

  File? _frontImage;
  File? _backImage;
  bool _isFront = true; // initially capturing front side
  String? hint;

  @override
  void initState() {
    super.initState();
    hint = widget.hintText;
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

  Future<void> _pickFromGallery() async {
    final XFile? pic = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pic != null) _storeCapturedImage(File(pic.path));
  }

  Future<void> _capture() async {
    final XFile pic = await _controller.takePicture();
    _storeCapturedImage(File(pic.path));
  }

  void _storeCapturedImage(File file) {
    setState(() {
      if (_isFront) {
        _frontImage = file;
      } else {
        _backImage = file;
      }
    });

    widget.onImageCaptured(file, _isFront);
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
                        Text(widget.title, style: Theme.of(context).textTheme.bodyLarge),
                        // Front/Back toggle
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              _isFront
                                  ? AppLocalizations.of(context)!.frontSideString
                                  : AppLocalizations.of(context)!.backSide,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: primaryColor, fontSize: 16),
                            ),
                            Switch(
                              value: _isFront,
                              activeColor: primaryColor,
                              inactiveThumbColor: secondaryColor,
                              inactiveTrackColor: Colors.grey,
                              onChanged: (val) {
                                setState(() => _isFront = !_isFront);

                                setState(() {
                                  if (_isFront) {
                                    if (hint!.contains(AppLocalizations.of(context)!.backSide)) {
                                      hint = widget.hintText.replaceAll(
                                          AppLocalizations.of(context)!.backSide,
                                          AppLocalizations.of(context)!.frontSideString);
                                    }
                                  } else {
                                    if (hint!
                                        .contains(AppLocalizations.of(context)!.frontSideString)) {
                                      hint = widget.hintText.replaceAll(
                                        AppLocalizations.of(context)!.frontSideString,
                                        AppLocalizations.of(context)!.backSide,
                                      );
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        // TextButton(
                        //   onPressed: () {

                        //   },
                        //   child: Text(
                        //     _isFront ? 'Switch to Back Side' : 'Switch to Front Side',
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .bodyMedium
                        //         ?.copyWith(color: primaryColor, fontSize: 16),
                        //   ),
                        // ),
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
                                  hint ?? widget.hintText,
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
                        // Preview thumbnail
                        if ((_isFront ? _frontImage : _backImage) != null)
                          GestureDetector(
                            onTap: () {
                              final file = _isFront ? _frontImage : _backImage;
                              if (file != null) {
                                context.pushNamed(
                                  fullImagePreviewScreen,
                                  extra: {'imageFile': file},
                                );
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                _isFront ? _frontImage! : _backImage!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 60, height: 60),
                        // SizedBox(width: size.width * 0.109), // spacer (for symmetry)
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
