import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/features/base/view/base_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  bool showSecondLogo = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showSecondLogo = true; // بعد ما يخلص الفيد الأول يظهر الثاني
        });

        Future.delayed(const Duration(seconds: 2), () {
          navigateAndFinish(context, BaseScreen());
        });
      }
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/png/splash.png",
            fit: BoxFit.cover,
          ),

          // Container fading
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeRadialGradient,
                  ),
                ),
              );
            },
          ),

          // Logo Section
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: showSecondLogo
                  ? AnimatedOpacity(
                      opacity: 1,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      child: Image.asset(
                        "assets/images/png/alber-logo.png",
                        width: 202.83871459960938.w,
                        height: 192.h,
                        fit: BoxFit.contain,
                      ),
                    )
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: Image.asset(
                        "assets/images/png/alber-text-logo.png",
                        width: 124.7096710205078.w,
                        height: 99.09677124023438.h,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
