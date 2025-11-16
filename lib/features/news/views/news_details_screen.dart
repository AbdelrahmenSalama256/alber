import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/constants/widgets/custom_scaffold.dart';
import 'package:qafeel/features/home/view/widgets/custom_top_bar.dart';

import '../../../core/constants/app_colors.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasShape: false,
      appBar: CustomTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  "assets/images/png/details.png",
                  width: double.infinity,
                  height: 165.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'جمعية البر بجدة تحصل على شهادة "تكامل" كأفضل بيئة عمل إبداعية لعام 2025',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  //! Glassmorphism info container
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.28),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'تنظم جمعية البر بجدة بالتعاون مع مجمع رعاية درياق الطبي غداً الاحد فعالية صحية توعوية لمنسوبيها تحت عنوان: “صحتي في غذائي”.تستهدف الفعالية رفع الوعي الصحي لدى الموظفين والزوار بنمط الغذاء الصحي، والكشف المبكر عن بعض الأمراض، مع تقديم نصائح حول التغذية والعادات الصحية  السليمة، بهدف تعزيز السلوكيات الصحية الإيجابية لديهم، وتشجيعهم على  ممارسة نمط حياة صحي وإكسابهم المفاهيم المرتبطة بالنشاط البدني والتغذية  الصحية.يتخلل الفعالية توزيع عدد من المطويات التوعوية على الموظفين، وقياس المؤشرات  الحيوية (الضغط، السكر، النبض، الحرارة، معدل التنفس) والإحصائيات الحيوية  الأخرى (الوزن، الطول).وتأتي هذه الفعالية امتداداً لسلسلة من النشاطات التوعوية الصحية التي نفذتها  الجمعية بالتعاون مع شركائها لتعزيز الصحة العامة لدى منسوبيها بما يحقق  أهدافها الاستراتيجية في المحور الصحي التي تعكس رؤيتها في ريادة صناعة  الأثر المجتمعي المستدام',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 2.5,
                      ),
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
