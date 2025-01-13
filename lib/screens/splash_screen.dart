import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:news_app/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _showProgressIndicator = false;
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOutCubic,
    );

    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );

    // Start the logo animation
    _logoController.forward();

    // Show the progress indicator after 2.5 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showProgressIndicator = true;
        _textController.forward();
      });
    });

    // Navigate to the next screen after 4.5 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const HomeScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A148C), // Deep Purple
              Color(0xFF2A5298), // Lighter Blue
            ],
          ),
        ),
        child: Stack(
          children: [
            // Optional blurred background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.3),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _logoAnimation,
                    child: Image.asset(
                      'assets/images/news_app_logo.png',
                      width: width * 0.35,
                      height: height * 0.35,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error,
                            size: width * 0.35, color: Colors.red);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _textAnimation,
                    child: Text(
                      "Stay Informed, Stay Ahead",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          const Shadow(
                            blurRadius: 4.0,
                            color: Colors.black26,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  if (_showProgressIndicator)
                    const SpinKitCircle(
                      color: Colors.white,
                      size: 50,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
