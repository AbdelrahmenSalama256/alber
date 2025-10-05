import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              hasShape
                  ? "assets/images/png/bg-one.jpeg"
                  : "assets/images/png/bg-two.jpeg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          left: false,
          right: false,
          top: false,
          child: body ?? const SizedBox(),
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
