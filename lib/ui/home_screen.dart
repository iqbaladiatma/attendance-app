import 'dart:ui';
import 'package:attendance_app/ui/absent/absent_screen.dart';
import 'package:attendance_app/ui/attend/attend_screen.dart';
import 'package:attendance_app/ui/attendance_history/attendance_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF4FC3F7).withOpacity(0.3),
                      const Color(0xFF4FC3F7).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF9575CD).withOpacity(0.3),
                      const Color(0xFF9575CD).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.3,
              right: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF4DB6AC).withOpacity(0.2),
                      const Color(0xFF4DB6AC).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            
            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Header section
                    GlassmorphicContainer(
                      width: double.infinity,
                      height: 120,
                      borderRadius: 25,
                      blur: 20,
                      alignment: Alignment.center,
                      border: 2,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFffffff).withOpacity(0.15),
                          const Color(0xFFFFFFFF).withOpacity(0.05),
                        ],
                      ),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFffffff).withOpacity(0.6),
                          const Color(0xFFFFFFFF).withOpacity(0.3),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4FC3F7),
                                        Color(0xFF29B6F6),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4FC3F7).withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.fingerprint,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Welcome Back!",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Attendance System",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Menu title
                    const Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 20),
                      child: Text(
                        "Quick Actions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    
                    // Menu items
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildModernMenuItem(
                            context,
                            icon: Icons.how_to_reg_rounded,
                            title: 'Attendance Record',
                            subtitle: 'Mark your presence',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                            ),
                            destination: const AttendScreen(),
                          ),
                          const SizedBox(height: 20),
                          _buildModernMenuItem(
                            context,
                            icon: Icons.event_busy_rounded,
                            title: 'Permission Request',
                            subtitle: 'Submit leave application',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9575CD), Color(0xFF7E57C2)],
                            ),
                            destination: const AbsentScreen(),
                          ),
                          const SizedBox(height: 20),
                          _buildModernMenuItem(
                            context,
                            icon: Icons.history_rounded,
                            title: 'Attendance History',
                            subtitle: 'View your records',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4DB6AC), Color(0xFF26A69A)],
                            ),
                            destination: const AttendanceHistoryScreen(),
                          ),
                        ],
                      ),
                    ),
                    
                    // Bottom info card
                    const SizedBox(height: 20),
                    GlassmorphicContainer(
                      width: double.infinity,
                      height: 70,
                      borderRadius: 20,
                      blur: 15,
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
                          const Color(0xFFFFFFFF).withOpacity(0.3),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.white.withOpacity(0.7),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Powered by Flutter",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required Widget destination,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      borderRadius: BorderRadius.circular(25),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 110,
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
            const Color(0xFFFFFFFF).withOpacity(0.3),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Icon container with gradient
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              const SizedBox(width: 20),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}