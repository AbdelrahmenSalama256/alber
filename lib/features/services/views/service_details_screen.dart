import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/app/alber.dart';
import 'package:qafeel/core/component/custom_toast.dart';
import 'package:qafeel/core/constants/app_colors.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/navigation.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/auth_return.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/auth/view/phone_confirm_screen.dart';
import 'package:qafeel/features/cart/views/add_donation_cart_screen.dart';
import 'package:qafeel/features/home/data/repo/home_repo.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';
import 'package:qafeel/features/home/view/widgets/donation_card.dart';
import 'package:qafeel/features/services/views/cubit/service_details_cubit.dart';
import 'package:qafeel/features/services/views/cubit/service_details_state.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel? service;
  final String? serviceId;
  final Color? color;

  const ServiceDetailsScreen({
    super.key,
    this.service,
    this.serviceId,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedId = serviceId ?? service?.id;
    return BlocProvider(
      create: (_) => ServiceDetailsCubit(
        homeRepo: sl<HomeRepo>(),
        initialService: service,
      )..loadService(resolvedId),
      child: BlocBuilder<ServiceDetailsCubit, ServiceDetailsState>(
        builder: (context, state) {
          return CustomScaffold(
            appBar: CustomTopBar(),
            hasShape: false,
            body: _ServiceDetailsBody(
              color: color,
              state: state,
            ),
          );
        },
      ),
    );
  }
}

class _ServiceDetailsBody extends StatelessWidget {
  final Color? color;
  final ServiceDetailsState state;

  const _ServiceDetailsBody({
    required this.color,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final service = state.service;

    if (service == null) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return Center(
        child: Text(state.error ?? 'Service details unavailable'),
      );
    }

    final language = context.read<GlobalCubit>().language;
    final accent = color ?? AppColors.primary;
    final description = _resolveDescription(service, language);
    final multiValues = _extractMultiValues(service);
    final initialAmount = _resolveInitialAmount(service, multiValues);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            if (state.isLoading)
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: const LinearProgressIndicator(minHeight: 2),
              ),
            _HeaderSection(
              accent: accent,
              imagePath: service.image,
              title: service.titleForLanguage(language),
            ),
            if (description.isNotEmpty) ...[
              SizedBox(height: 15.h),
              Text(
                description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF707070),
                  fontSize: 14.sp,
                  height: 1.7,
                ),
              ),
            ],
            SizedBox(height: 30.h),
            DonationCard(
              bg: Colors.transparent,
              title: service.titleForLanguage(language),
              imageAsset: service.image.isNotEmpty
                  ? service.image
                  : 'assets/images/png/news.png',
              raised: service.collectedAmount ?? 0,
              goal: service.goalAmount ?? 0,
              initialAmount: initialAmount,
              initialQty: 1,
              multiValues: multiValues,
              accent: accent,
              onDonateWithSelection: (amount, qty, _) =>
                  _handleDonate(context, amount, qty),
            ),
            if (state.error != null && !state.isLoading) ...[
              SizedBox(height: 20.h),
              Text(
                state.error!,
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _resolveDescription(ServiceModel service, String language) {
    if (language == 'ar' && (service.detailsAr?.isNotEmpty ?? false)) {
      return service.detailsAr!;
    }
    if (service.details?.isNotEmpty ?? false) {
      return service.details!;
    }
    return service.summaryForLanguage(language);
  }

  List<double?>? _extractMultiValues(ServiceModel service) {
    final pricing = service.metadata?['pricing'];
    if (pricing is Map<String, dynamic>) {
      final options = [
        _toDouble(pricing['multi1']),
        _toDouble(pricing['multi2']),
        _toDouble(pricing['multi3']),
      ];
      if (options.any((value) => value != null)) {
        return options;
      }
    }
    return null;
  }

  double _resolveInitialAmount(
      ServiceModel service, List<double?>? multiValues) {
    final pricing = service.metadata?['pricing'];
    final candidates = <double>[
      if (service.minAmount != null && service.minAmount! > 0)
        service.minAmount!,
      if (pricing is Map<String, dynamic>)
        ...[
          _toDouble(pricing['basic']),
        ].whereType<double>(),
      if (multiValues != null)
        ...multiValues.whereType<double>(),
    ];

    if (candidates.isNotEmpty) {
      candidates.sort();
      return candidates.first;
    }
    return 1;
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  void _handleDonate(BuildContext context, double amount, int qty) {
    final token = sl<CacheHelper>().getDataString(key: AppConstants.token);
    if (token == null || token.isEmpty) {
      showToast(context,
          message: 'login'.tr(context), state: ToastStates.warning);
      sl<AuthReturnService>().setPendingAction(() {
        navigateTo(
          navigatorKey.currentContext!,
          AddDonationCartScreen(
            initialAmount: amount.round(),
            initialQty: qty,
          ),
        );
      });
      navigateTo(context, const PhoneConfirmScreen());
      return;
    }
    navigateTo(
      context,
      AddDonationCartScreen(
        initialAmount: amount.round(),
        initialQty: qty,
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final Color accent;
  final String imagePath;
  final String title;

  const _HeaderSection({
    required this.accent,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: accent.withOpacity(0.4),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _ServiceImage(imagePath: imagePath),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: accent,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceImage extends StatelessWidget {
  final String imagePath;

  const _ServiceImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: 150.w,
      height: 100.h,
      decoration: BoxDecoration(
        color: AppColors.textGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        Icons.photo,
        size: 32.sp,
        color: AppColors.textGrey,
      ),
    );

    if (imagePath.isEmpty) {
      return placeholder;
    }

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 150.w,
        height: 100.h,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }

    return Image.asset(
      imagePath,
      width: 150.w,
      height: 100.h,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
