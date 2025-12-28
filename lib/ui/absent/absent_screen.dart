import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attendance_app/ui/home_screen.dart';
import 'package:glassmorphism/glassmorphism.dart';

class AbsentScreen extends StatefulWidget {
  const AbsentScreen({super.key});

  @override
  State<AbsentScreen> createState() => _AbsentScreenState();
}

class _AbsentScreenState extends State<AbsentScreen> {
  var categoriesList = <String>[
    "Please Choose:",
    "Others",
    "Permission",
    "Sick",
  ];

  final controllerName = TextEditingController();
  double dLat = 0.0, dLong = 0.0;
  final CollectionReference dataCollection = FirebaseFirestore.instance
      .collection('attendance');

  int dateHours = 0, dateMinutes = 0;
  String dropValueCategories = "Please Choose:";
  final fromController = TextEditingController();
  String strAlamat = '', strDate = '', strTime = '', strDateTime = '';
  final toController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: const Color(0xFF1A237E),
      content: Row(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9575CD)),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text(
              "Please Wait...",
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

  Future<void> submitAbsen(
    String nama,
    String keterangan,
    String from,
    String until,
  ) async {
    if (nama.isEmpty ||
        keterangan == "Please Choose:" ||
        from.isEmpty ||
        until.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Pastikan semua data telah diisi!",
                style: TextStyle(color: Colors.white),
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
      return;
    }

    showLoaderDialog(context);

    try {
      await dataCollection.add({
        'address': '-',
        'name': nama,
        'description': keterangan,
        'datetime': '$from - $until',
        'created_at': FieldValue.serverTimestamp(),
      });

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
    } catch (e) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Ups, terjadi kesalahan: $e",
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
                          "Permission Request Menu",
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
                      height: 600,
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
                                  const Color(0xFF9575CD).withOpacity(0.6),
                                  const Color(0xFF7E57C2).withOpacity(0.4),
                                ],
                              ),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(width: 20),
                                Icon(Icons.maps_home_work_outlined, color: Colors.white),
                                SizedBox(width: 12),
                                Text(
                                  "Please Fill out the Form!",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: TextField(
                              textInputAction: TextInputAction.next,
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
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                              child: DropdownButton(
                                dropdownColor: const Color(0xFF1A237E),
                                value: dropValueCategories,
                                onChanged: (value) {
                                  setState(() {
                                    dropValueCategories = value.toString();
                                  });
                                },
                                items: categoriesList.map((value) {
                                  return DropdownMenuItem(
                                    value: value.toString(),
                                    child: Text(
                                      value.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                underline: Container(height: 2, color: Colors.transparent),
                                isExpanded: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "From:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                            builder: (BuildContext context, Widget? child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: const ColorScheme.light(
                                                    onPrimary: Colors.white,
                                                    onSurface: Colors.white,
                                                    primary: Color(0xFF9575CD),
                                                  ),
                                                  datePickerTheme: const DatePickerThemeData(
                                                    headerBackgroundColor: Color(0xFF9575CD),
                                                    backgroundColor: Color(0xFF1A237E),
                                                    headerForegroundColor: Colors.white,
                                                    surfaceTintColor: Colors.white,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(9999),
                                          );
                                          if (pickedDate != null) {
                                            fromController.text = DateFormat('dd/M/yyyy').format(pickedDate);
                                          }
                                        },
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                        controller: fromController,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(12),
                                          hintText: "Starting From",
                                          hintStyle: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 14,
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Until:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                            builder: (BuildContext context, Widget? widget) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: const ColorScheme.light(
                                                    onPrimary: Colors.white,
                                                    onSurface: Colors.white,
                                                    primary: Color(0xFF9575CD),
                                                  ),
                                                  datePickerTheme: const DatePickerThemeData(
                                                    headerBackgroundColor: Color(0xFF9575CD),
                                                    backgroundColor: Color(0xFF1A237E),
                                                    headerForegroundColor: Colors.white,
                                                    surfaceTintColor: Colors.white,
                                                  ),
                                                ),
                                                child: widget!,
                                              );
                                            },
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(9999),
                                          );
                                          if (pickedDate != null) {
                                            toController.text = DateFormat('dd/M/yyyy').format(pickedDate);
                                          }
                                        },
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                        controller: toController,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(12),
                                          hintText: "Until",
                                          hintStyle: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 14,
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                                  const Color(0xFF9575CD).withOpacity(0.8),
                                  const Color(0xFF7E57C2).withOpacity(0.6),
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
                                  if (controllerName.text.isEmpty ||
                                      dropValueCategories == "Please Choose:" ||
                                      fromController.text.isEmpty ||
                                      toController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Row(
                                          children: [
                                            Icon(Icons.info_outline, color: Colors.white),
                                            SizedBox(width: 10),
                                            Text(
                                              "Ups, please fill the form!",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: const Color(0xFF9575CD),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  } else {
                                    submitAbsen(
                                      controllerName.text.toString(),
                                      dropValueCategories.toString(),
                                      fromController.text,
                                      toController.text,
                                    );
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    "Make a Request",
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
}