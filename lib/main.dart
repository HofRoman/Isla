import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'providers/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const IslaApp(),
    ),
  );
}

class IslaApp extends StatelessWidget {
  const IslaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isla – Islamische App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.5, curve: Curves.easeIn)),
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.elasticOut)),
    );
    _slideAnim = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              pageBuilder: (_, __, ___) => const HomeScreen(),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.black,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '☪',
                          style: TextStyle(fontSize: 60, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Transform.translate(
                  offset: Offset(0, _slideAnim.value),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        Text(
                          'إسلا',
                          style: TextStyle(
                            fontFamily: 'Scheherazade New',
                            fontSize: 48,
                            color: AppTheme.black,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ISLA',
                          style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 8,
                            color: AppTheme.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Islamische Wissens App',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.mediumGrey,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
