import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController subjectC = TextEditingController();
  final TextEditingController messageC = TextEditingController();
  String? topic;

  Future<void> init() async {
    emit(ProfileLoading());
    await Future.delayed(const Duration(seconds: 2));
    final about = _about();
    final privacy = _longPolicy();
    final terms = _longPolicy();
    final history = _history();
    final locs = _locations();
    emit(ProfileLoaded(
      aboutText: about,
      privacyText: privacy,
      termsText: terms,
      donationHistory: history,
      locations: locs,
      totalAmount: "35000",
      totalCount: "350",
    ));
  }

  void setTopic(String? v) {
    topic = v;
    final s = state;
    if (s is ProfileLoaded) emit(s.copyWith());
  }

  List<Map<String, String>> _history() {
    return [
      {
        "tag": "إهداء",
        "code": "BIR-060278",
        "date": "25 - 08 - 2025",
        "time": "16:30:00",
        "amount": "1123.00"
      },
      {
        "tag": "تبرع",
        "code": "BIR-060310",
        "date": "26 - 08 - 2025",
        "time": "10:15:00",
        "amount": "250.00"
      },
    ];
  }

  List<Map<String, String>> _locations() {
    return List.generate(3, (i) {
      return {
        "title": "المقر الرئيسي",
        "desc":
            "اهلا بكم في المقر الرئيسي جدة شارع احمد العطاس تقاطع البترجي موازي مستشفى السعودي الالماني",
        "image": "assets/images/png/map.png",
        "icon": "assets/images/svg/map-marker.svg"
      };
    });
  }

  String _about() {
    return "تأسست جمعية البر بجدة في 25/12/1402هـ وهي جمعية خيرية ذات شخصية اعتبارية تشمل خدماتها محافظة جدة وما حولها من القرى , ورئيسها الفخري صاحب السمو الملكي أمير منطقة مكة المكرمة , وتعمل تحت إشراف وزارة الموارد البشرية والتنمية الاجتماعية ومسجلة برقم 62 .";
  }

  String _longPolicy() {
    return 'مرحبًا بكم في موقع جمعية البر بجدة (albir.sa). يُرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام الموقع. من خلال استخدامك للموقع، فإنك توافق على هذه الشروط وتلتزم بها بشكل كامل. إذا كنت غير موافق على هذه الشروط، يُرجى عدم استخدام الموقع. المحتوى والملكية الفكرية: جميع حقوق الملكية الفكرية للمحتوى المعروض على الموقع هي ملك جمعية البر بجدة أو تُستخدم بإذن من المالك. يُمنع نسخ، تعديل، نشر، توزيع أو استخدام أي محتوى من الموقع لأغراض تجارية دون الحصول على إذن خطي من جمعية البر بجدة. الاستخدام الشخصي: الموقع مخصص للاستخدام الشخصي والغير تجاري فقط. يُحظر استخدام الموقع بأي شكل من الأشكال لأغراض تجارية أو غير قانونية. يُحظر استخدام الموقع بطريقة تتسبب في التشويش أو الإزعاج للآخرين أو تعرض الموقع للخطر. الروابط الخارجية: يحتوي الموقع على روابط تؤدي إلى مواقع خارجية. نود التنويه إلى أن جمعية البر بجدة ليست مسؤولة عن محتوى تلك المواقع الخارجية ولا تتحمل أي مسؤولية عن أي خسائر أو أضرار قد تنشأ عن استخدام تلك المواقع. الخصوصية: نحن نولي اهتمامًا كبيرًا بحماية خصوصية المستخدمين للموقع. يُرجى قراءة سياسة الخصوصية الخاصة بالموقع لفهم كيفية جمع واستخدام ومشاركة المعلومات الشخصية. التعديلات على الشروط والأحكام: يحتفظ فريق جمعية البر بجدة بالحق في تعديل هذه الشروط والأحكام في أي وقت دون إشعار مسبق. يتم نشر أية تعديلات على الشروط والأحكام في هذه الصفحة، ويتم اعتبار استمرار استخدامك للموقع بعد التعديلات كموافقة على تلك التعديلات. الدعم والتواصل: للتواصل مع فريق جمعية البر بجدة أو الحصول على الدعم، يُرجى استخدام معلومات الاتصال المتاحة على الموقع.';
  }

  @override
  Future<void> close() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    subjectC.dispose();
    messageC.dispose();
    return super.close();
  }
}
