import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/services/service_locator.dart';

import '../custom_toast.dart';

class ProfileImagePicker extends StatelessWidget {
  final XFile? profileImage;
  final String? initialImage;
  final Function(XFile) onImageSelected;
  final double size;
  final Color backgroundColor;
  final Color editIconBackgroundColor;
  final Color editIconColor;

  const ProfileImagePicker({
    super.key,
    this.profileImage,
    this.initialImage,
    required this.onImageSelected,
    this.size = 100,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.editIconBackgroundColor = Colors.white,
    this.editIconColor = AppColors.primary,
  });

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image != null) {
        onImageSelected(image);
      }
    } catch (e) {
      if (!context.mounted) return;
      showToast(
        context,
        message: 'error_picking_image'.tr(context),
        state: ToastStates.error,
      );
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    final radiusXl = sl<GlobalCubit>().radiusXl;
    final radiusMd = sl<GlobalCubit>().radiusMd;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              0,
              16.w,
              16.h + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radiusXl.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(radiusXl.r),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: AppColors.textGrey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'select_image_source'.tr(context),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _ImageSourceTile(
                        icon: CupertinoIcons.photo_camera_solid,
                        label: 'camera'.tr(context),
                        radius: radiusMd,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _pickImage(ImageSource.camera, context);
                        },
                      ),
                      SizedBox(height: 8.h),
                      _ImageSourceTile(
                        icon: CupertinoIcons.photo_on_rectangle,
                        label: 'gallery'.tr(context),
                        radius: radiusMd,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _pickImage(ImageSource.gallery, context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? resolvedImage = _buildSelectedImage();
    resolvedImage ??= _buildInitialImageWidget();

    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Stack(
        children: [
          Container(
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: resolvedImage ?? _buildEmptyAvatar(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: (size * 0.24).w,
              height: (size * 0.24).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: editIconBackgroundColor,
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1.w,
                ),
              ),
              child: Icon(
                Icons.edit,
                size: (size * 0.14).w,
                color: editIconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildSelectedImage() {
    if (profileImage == null) return null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.file(
        File(profileImage!.path),
        width: size.w,
        height: size.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget? _buildInitialImageWidget() {
    if (initialImage == null || initialImage!.isEmpty) return null;
    final path = initialImage!;
    final border = BorderRadius.circular(size / 2);

    if (path.startsWith('http')) {
      return ClipRRect(
        borderRadius: border,
        child: Image.network(
          path,
          width: size.w,
          height: size.w,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildEmptyAvatar(),
        ),
      );
    }

    if (path.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: border,
        child: Image.asset(
          path,
          width: size.w,
          height: size.w,
          fit: BoxFit.cover,
        ),
      );
    }

    final file = File(path);
    if (file.existsSync()) {
      return ClipRRect(
        borderRadius: border,
        child: Image.file(
          file,
          width: size.w,
          height: size.w,
          fit: BoxFit.cover,
        ),
      );
    }
    return null;
  }

  Widget _buildEmptyAvatar() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: (size * 0.4).w,
            height: (size * 0.4).w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: 5.h),
          Container(
            width: (size * 0.5).w,
            height: (size * 0.2).h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(size * 0.1)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageSourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final double radius;
  final VoidCallback onTap;

  const _ImageSourceTile({
    required this.icon,
    required this.label,
    required this.radius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius.r),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(radius.r),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
