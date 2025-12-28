import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:lottie/lottie.dart';
import 'package:attendance_app/ui/attend/attend_screen.dart';
import 'package:attendance_app/utils/face_detection/google_ml_kit.dart';
import 'package:glassmorphism/glassmorphism.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _State();
}

class _State extends State<CameraScreen> with TickerProviderStateMixin {
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(
    FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableTracking: true,
      enableLandmarks: true,
    ),
  );

  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  bool isBusy = false;

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  Future<void> loadCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras != null && cameras!.isNotEmpty) {
        final frontCamera = cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras!.first,
        );

        controller = CameraController(frontCamera, ResolutionPreset.medium);

        try {
          await controller!.initialize();
          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          debugPrint('Error initializing camera: $e');
          if (mounted) {
            _showCameraError('Camera initialization failed. Please check camera permissions in your browser.');
          }
        }
      } else {
        if (mounted) {
          _showCameraError('No camera found on this device.');
        }
      }
    } catch (e) {
      debugPrint('Error loading cameras: $e');
      if (mounted) {
        _showCameraError('Camera access denied. Please allow camera permission in your browser settings.');
      }
    }
  }

  void _showCameraError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.camera_enhance_outlined, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4FC3F7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: const Color(0xFF1A237E),
      content: Row(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FC3F7)),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text(
              "Checking the data...",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF0D47A1),
              Color(0xFF01579B),
              Color(0xFF006064),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
                child: controller == null
                    ? const Center(
                        child: Text(
                          "Ups, camera error!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : !controller!.value.isInitialized
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF4FC3F7),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CameraPreview(controller!),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Lottie.asset(
                  "assets/raw/face_id_ring.json",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: GlassmorphicContainer(
                  width: 50,
                  height: 50,
                  borderRadius: 15,
                  blur: 20,
                  alignment: Alignment.center,
                  border: 2,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFffffff).withOpacity(0.1),
                      const Color(0xFFFFFFFF).withOpacity(0.05),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFffffff).withOpacity(0.5),
                      const Color(0xFFFFFFFF).withOpacity(0.5),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GlassmorphicContainer(
                    width: size.width,
                    height: 200,
                    borderRadius: 28,
                    blur: 20,
                    alignment: Alignment.center,
                    border: 2,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFffffff).withOpacity(0.15),
                        const Color(0xFFFFFFFF).withOpacity(0.08),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFffffff).withOpacity(0.5),
                        const Color(0xFFFFFFFF).withOpacity(0.5),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Make sure you're in a well-lit area so your face is clearly visible.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GlassmorphicContainer(
                          width: 70,
                          height: 70,
                          borderRadius: 35,
                          blur: 10,
                          alignment: Alignment.center,
                          border: 2,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF4FC3F7).withOpacity(0.8),
                              const Color(0xFF29B6F6).withOpacity(0.6),
                            ],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFffffff).withOpacity(0.6),
                              const Color(0xFFFFFFFF).withOpacity(0.6),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(35),
                            onTap: () async {
                              final hasPermission = await handleLocationPermission();
                              try {
                                if (controller != null) {
                                  if (controller!.value.isInitialized) {
                                    controller!.setFlashMode(FlashMode.off);
                                    image = await controller!.takePicture();
                                    if (mounted) {
                                      setState(() {
                                        if (hasPermission) {
                                          showLoaderDialog(context);
                                          final inputImage = InputImage.fromFilePath(image!.path);
                                          Platform.isAndroid
                                              ? processImage(inputImage)
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => AttendScreen(image: image),
                                                  ),
                                                );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Row(
                                                children: [
                                                  Icon(Icons.location_on_outlined, color: Colors.white),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Please allow the permission first!",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              backgroundColor: const Color(0xFF4FC3F7),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      });
                                    }
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.error_outline, color: Colors.white),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "Ups, $e",
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Icon(
                              Icons.camera_enhance_outlined,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.location_off, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Location services are disabled. Please enable the services.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF4FC3F7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      debugPrint("Layanan lokasi tidak aktif, silakan aktifkan GPS.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.location_off, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Location permission denied.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF4FC3F7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.location_off, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Location permission denied forever, we cannot access.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF4FC3F7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }
    return true;
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    isBusy = false;

    if (mounted) {
      setState(() {
        Navigator.of(context).pop(true);
        if (faces.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AttendScreen(image: image)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.face_retouching_natural_outlined, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Ups, make sure that you're face is clearly visible!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF4FC3F7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }
  }
}
