import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:attendance_app/ui/attend/camera_screen.dart';
import 'package:attendance_app/ui/home_screen.dart';
import 'package:glassmorphism/glassmorphism.dart';

class AttendScreen extends StatefulWidget {
  final XFile? image;

  const AttendScreen({super.key, this.image});

  @override
  State<AttendScreen> createState() => _AttendScreenState();
}

class _AttendScreenState extends State<AttendScreen> {
  XFile? image;
  String strAlamat = "",
      strDate = "",
      strTime = "",
      strDateTime = "",
      strStatus = "Attend";
  bool isLoading = false;
  double dLat = 0.0, dLong = 0.0;
  int dateHours = 0, dateMinutes = 0;
  final controllerName = TextEditingController();
  final CollectionReference dataCollection = FirebaseFirestore.instance
      .collection('attendance');

  @override
  void initState() {
    super.initState();
    image = widget.image;
    setDateTime();
    setStatusAbsen();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final hasPermission = await handleLocationPermission();
    if (hasPermission && image != null) {
      setState(() {
        isLoading = true;
      });
      await getGeoLocationPosition();
    } else if (image != null) {
      setState(() {
        strAlamat = "Location not available";
        isLoading = false;
      });
    }
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GlassmorphicContainer(
                  width: double.infinity,
                  height: 60,
                  borderRadius: 20,
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
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          "Attendance Menu",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GlassmorphicContainer(
                      width: double.infinity,
                      height: 650,
                      borderRadius: 25,
                      blur: 15,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF4FC3F7).withOpacity(0.6),
                                  const Color(0xFF29B6F6).withOpacity(0.4),
                                ],
                              ),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(width: 20),
                                Icon(Icons.face_retouching_natural_outlined, color: Colors.white),
                                SizedBox(width: 12),
                                Text(
                                  "Please make a selfie photo!",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Text(
                              "Capture Photo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (kIsWeb) {
                                // For web, use image picker
                                final ImagePicker picker = ImagePicker();
                                final XFile? pickedImage = await picker.pickImage(
                                  source: ImageSource.camera,
                                  preferredCameraDevice: CameraDevice.front,
                                );
                                if (pickedImage != null) {
                                  setState(() {
                                    image = pickedImage;
                                    isLoading = true;
                                  });
                                  await getGeoLocationPosition();
                                }
                              } else {
                                // For mobile, use camera screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CameraScreen(),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              width: size.width,
                              height: 150,
                              child: DottedBorder(
                                radius: const Radius.circular(15),
                                borderType: BorderType.RRect,
                                color: Colors.white.withOpacity(0.6),
                                strokeWidth: 2,
                                dashPattern: const [8, 4],
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                  child: SizedBox.expand(
                                    child: image != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: kIsWeb
                                                ? Image.network(
                                                    image!.path,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    File(image!.path),
                                                    fit: BoxFit.cover,
                                                  ),
                                          )
                                        : Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.camera_enhance_outlined,
                                                color: Colors.white.withOpacity(0.6),
                                                size: 60,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                kIsWeb ? 'Click to capture' : 'Tap to take photo',
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.6),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              controller: controllerName,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                labelText: "Your Name",
                                hintText: "Please enter your name",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                labelStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Text(
                              "Your Location",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          isLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF4FC3F7),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white.withOpacity(0.1),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      strAlamat.isEmpty ? "Fetching location..." : strAlamat,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(30),
                            child: GlassmorphicContainer(
                              width: size.width,
                              height: 55,
                              borderRadius: 20,
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
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  if (image == null || controllerName.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Row(
                                          children: [
                                            Icon(Icons.info_outline, color: Colors.white),
                                            SizedBox(width: 10),
                                            Text(
                                              "Please Fill all the forms!",
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
                                  } else {
                                    submitAbsen(
                                      strAlamat,
                                      controllerName.text.toString(),
                                      strStatus,
                                    );
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    "Report Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Future<void> getGeoLocationPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Location timeout');
        },
      );
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        await getAddressFromLongLat(position);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          strAlamat = "Location unavailable (using web browser)";
        });
      }
    }
  }

  Future<void> getAddressFromLongLat(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (mounted) {
          setState(() {
            dLat = position.latitude;
            dLong = position.longitude;
            strAlamat =
                "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          dLat = position.latitude;
          dLong = position.longitude;
          strAlamat = "Lat: ${position.latitude.toStringAsFixed(4)}, Long: ${position.longitude.toStringAsFixed(4)}";
        });
      }
    }
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
                Text(
                  "Location services are disabled. Please enable the services.",
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

  void setDateTime() async {
    var dateNow = DateTime.now();
    var dateFormat = DateFormat('dd MMMM yyyy');
    var dateTime = DateFormat('HH:mm:ss');
    var dateHour = DateFormat('HH');
    var dateMinute = DateFormat('mm');

    setState(() {
      strDate = dateFormat.format(dateNow);
      strTime = dateTime.format(dateNow);
      strDateTime = "$strDate | $strTime";

      dateHours = int.parse(dateHour.format(dateNow));
      dateMinutes = int.parse(dateMinute.format(dateNow));
    });
  }

  void setStatusAbsen() {
    if (dateHours < 8 || (dateHours == 8 && dateMinutes <= 30)) {
      strStatus = "Attend";
    } else if ((dateHours > 8 && dateHours < 18) ||
        (dateHours == 8 && dateMinutes >= 31)) {
      strStatus = "Late";
    } else {
      strStatus = "Leave";
    }
  }

  Future<void> submitAbsen(String alamat, String nama, String status) async {
    showLoaderDialog(context);
    dataCollection
        .add({
          'address': alamat,
          'name': nama,
          'description': status,
          'datetime': strDateTime,
        })
        .then((result) {
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Yeay! Attendance Report Succeeded!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        })
        .catchError((error) {
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Ups, $error",
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
        });
  }
}