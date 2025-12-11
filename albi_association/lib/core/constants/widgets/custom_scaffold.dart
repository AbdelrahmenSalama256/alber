import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final bool hasShape;

  const CustomScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.hasShape = true,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // choose base bg (solid or alternative)
    final bgImage = hasShape
        ? "assets/images/png/bg-one.jpeg"
        : "assets/images/png/bg-two.jpeg";

    // pattern overlay file (transparent PNG or shape image)
    const patternImage = "assets/images/png/pattern.png";

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// Base background
            Image.asset(
              bgImage,
              fit: BoxFit.cover,
            ),

            /// Pattern overlay that always fills the screen
            Image.asset(
              patternImage,
              fit: BoxFit.cover,
              color: hasShape
                  ? Colors.white.withOpacity(0.12) // subtle overlay
                  : Colors.white.withOpacity(0.08),
              colorBlendMode: BlendMode.srcOver,
            ),

            /// Content
            SafeArea(
              left: false,
              right: false,
              top: false,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: bottomInset),
                child: body ?? const SizedBox(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton != null
          ? Container(
              margin: EdgeInsets.only(bottom: 20.h),
              child: floatingActionButton,
            )
          : null,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
