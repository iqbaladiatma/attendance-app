import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final CollectionReference dataCollection = FirebaseFirestore.instance
      .collection('attendance');

  void _editData(
    String docId,
    String currentName,
    String currentAddress,
    String currentDescription,
    String currentDatetime,
  ) {
    TextEditingController nameController = TextEditingController(
      text: currentName,
    );
    TextEditingController addressController = TextEditingController(
      text: currentAddress,
    );
    TextEditingController descriptionController = TextEditingController(
      text: currentDescription,
    );
    TextEditingController datetimeController = TextEditingController(
      text: currentDatetime,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Edit Data",
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF4DB6AC)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Address",
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF4DB6AC)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF4DB6AC)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: datetimeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Datetime",
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF4DB6AC)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await dataCollection.doc(docId).update({
                'name': nameController.text,
                'address': addressController.text,
                'description': descriptionController.text,
                'datetime': datetimeController.text,
              });
              if (mounted) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Color(0xFF4DB6AC)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteData(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Delete Data",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure want to delete this data?",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await dataCollection.doc(docId).delete();
              if (mounted) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          "Attendance History Menu",
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: dataCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!.docs;
                      return data.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                var docId = data[index].id;
                                var name = data[index]['name'];
                                var address = data[index]['address'];
                                var description = data[index]['description'];
                                var datetime = data[index]['datetime'];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: GlassmorphicContainer(
                                    width: double.infinity,
                                    height: 160,
                                    borderRadius: 20,
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.primaries[Random().nextInt(
                                                    Colors.primaries.length,
                                                  )],
                                                  Colors.primaries[Random().nextInt(
                                                    Colors.primaries.length,
                                                  )].withOpacity(0.6),
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                name[0].toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  address,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white.withOpacity(0.8),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF4DB6AC).withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    description,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  datetime,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white.withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF4FC3F7).withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Color(0xFF4FC3F7),
                                                    size: 20,
                                                  ),
                                                  onPressed: () => _editData(
                                                    docId,
                                                    name,
                                                    address,
                                                    description,
                                                    datetime,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                  onPressed: () => _deleteData(docId),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: GlassmorphicContainer(
                                width: 250,
                                height: 100,
                                borderRadius: 20,
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
                                child: const Text(
                                  "Ups, there is no data!",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4DB6AC),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}