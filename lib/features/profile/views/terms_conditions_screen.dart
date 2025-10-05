import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/core/locale/app_loacl.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/constants/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/svg/security.svg",
                    width: 20.w,
                  ),
                  SizedBox(width: 20.h),
                  Text(
                    "terms_and_conditions".tr(context),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.18), // glassy fill
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.28),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'مرحبًا بكم في موقع جمعية البر بجدة (albir.sa). يُرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام الموقع. من خلال استخدامك للموقع، فإنك توافق على هذه الشروط وتلتزم بها بشكل كامل. إذا كنت غير موافق على هذه الشروط، يُرجى عدم استخدام الموقع. المحتوى والملكية الفكرية: جميع حقوق الملكية الفكرية للمحتوى المعروض على الموقع هي ملك جمعية البر بجدة أو تُستخدم بإذن من المالك. يُمنع نسخ، تعديل، نشر، توزيع أو استخدام أي محتوى من الموقع لأغراض تجارية دون الحصول على إذن خطي من جمعية البر بجدة. الاستخدام الشخصي: الموقع مخصص للاستخدام الشخصي والغير تجاري فقط. يُحظر استخدام الموقع بأي شكل من الأشكال لأغراض تجارية أو غير قانونية. يُحظر استخدام الموقع بطريقة تتسبب في التشويش أو الإزعاج للآخرين أو تعرض الموقع للخطر. الروابط الخارجية: يحتوي الموقع على روابط تؤدي إلى مواقع خارجية. نود التنويه إلى أن جمعية البر بجدة ليست مسؤولة عن محتوى تلك المواقع الخارجية ولا تتحمل أي مسؤولية عن أي خسائر أو أضرار قد تنشأ عن استخدام تلك المواقع. الخصوصية: نحن نولي اهتمامًا كبيرًا بحماية خصوصية المستخدمين للموقع. يُرجى قراءة سياسة الخصوصية الخاصة بالموقع لفهم كيفية جمع واستخدام ومشاركة المعلومات الشخصية. التعديلات على الشروط والأحكام: يحتفظ فريق جمعية البر بجدة بالحق في تعديل هذه الشروط والأحكام في أي وقت دون إشعار مسبق. يتم نشر أية تعديلات على الشروط والأحكام في هذه الصفحة، ويتم اعتبار استمرار استخدامك للموقع بعد التعديلات كموافقة على تلك التعديلات. الدعم والتواصل: للتواصل مع فريق جمعية البر بجدة أو الحصول على الدعم، يُرجى استخدام معلومات الاتصال المتاحة على الموقع.',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 2.3,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
