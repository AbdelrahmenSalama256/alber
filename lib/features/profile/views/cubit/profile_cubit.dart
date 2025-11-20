import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/cubit/app_cubit.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/features/profile/data/models/contact_model.dart';
import 'package:qafeel/features/profile/data/repo/profile_repo.dart';

import 'profile_state.dart';

class ProfileCubit extends AppCubit<ProfileState> {
  final ProfileRepo profileRepo;
  final GlobalCubit globalCubit;
  final CacheHelper cacheHelper;

  ProfileCubit({
    required this.profileRepo,
    required this.globalCubit,
    required this.cacheHelper,
  }) : super(ProfileInitial());

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController subjectC = TextEditingController();
  final TextEditingController messageC = TextEditingController();
  String? topic;

  Future<void> init() async {
    emitSafe(ProfileLoading());
    await Future.delayed(const Duration(seconds: 2));
    final about = _about();
    final privacy = _longPolicy();
    final terms = _longPolicy();
    final history = _history();
    final locs = _locations();
    emitSafe(ProfileLoaded(
      aboutText: about,
      privacyText: privacy,
      termsText: terms,
      donationHistory: history,
      locations: locs,
      totalAmount: "35000",
      totalCount: "350",
      profile: _defaultUser(),
      isUpdatingProfile: false,
      pendingAvatar: null,
      isEmailVerified: true,
      isPhoneVerified: true,
      pendingEmail: null,
      pendingPhone: null,
    ));
  }

  void toggleProfileEditing({bool? enabled}) {
    final current = state;
    if (current is! ProfileLoaded) return;
    final nextValue = enabled ?? !current.isEditingProfile;
    emitSafe(current.copyWith(isEditingProfile: nextValue));
  }

  void updateProfileField({
    String? name,
    String? memberId,
    String? phone,
    String? email,
  }) {
    final current = state;
    if (current is! ProfileLoaded) return;
    if (email != null) {
      updatePendingEmail(email);
      return;
    }
    if (phone != null) {
      updatePendingPhone(phone);
      return;
    }
    final updated = current.profile.copyWith(
      name: name,
      membershipId: memberId,
    );
    emitSafe(current.copyWith(profile: updated));
    globalCubit.updateCachedProfileValues(
      name: name,
      memberId: memberId,
    );
  }

  void updatePendingEmail(String email) {
    final current = state;
    if (current is! ProfileLoaded) return;
    final trimmed = email.trim();
    if (trimmed.isEmpty) return;
    emitSafe(
      current.copyWith(
        profile: current.profile.copyWith(email: trimmed),
        pendingEmail: trimmed,
        isEmailVerified: false,
      ),
    );
  }

  void updatePendingPhone(String phone) {
    final current = state;
    if (current is! ProfileLoaded) return;
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return;
    emitSafe(
      current.copyWith(
        profile: current.profile.copyWith(mobile: trimmed),
        pendingPhone: trimmed,
        isPhoneVerified: false,
      ),
    );
  }

  Future<void> updateProfileImage(XFile file) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    final originalState = current;
    emitSafe(
      current.copyWith(
        pendingAvatar: file,
        isUpdatingProfile: true,
      ),
    );
    final result = await profileRepo.updateProfile(avatarFile: file);
    result.fold(
      (error) {
        PrintUtil.error('profile_avatar_update_failed: $error');
        emitSafe(
          originalState.copyWith(
            pendingAvatar: null,
            isUpdatingProfile: false,
          ),
        );
      },
      (contact) {
        final updatedUser = contact.data.user;
        globalCubit.updateCachedProfileFromJson(updatedUser.toJson());
        emitSafe(
          originalState.copyWith(
            profile: updatedUser,
            pendingAvatar: null,
            isUpdatingProfile: false,
          ),
        );
      },
    );
  }

  Future<void> updateDisplayName(String name) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed == current.profile.name) return;
    final originalProfile = current.profile;
    emitSafe(
      current.copyWith(
        profile: originalProfile.copyWith(name: trimmed),
        isUpdatingProfile: true,
      ),
    );
    final result = await profileRepo.updateProfile(displayName: trimmed);
    result.fold(
      (error) {
        PrintUtil.error('profile_name_update_failed: $error');
        emitSafe(
          current.copyWith(
            profile: originalProfile,
            isUpdatingProfile: false,
          ),
        );
      },
      (contact) {
        final updatedUser = contact.data.user;
        globalCubit.updateCachedProfileFromJson(updatedUser.toJson());
        emitSafe(
          current.copyWith(
            profile: updatedUser,
            isUpdatingProfile: false,
          ),
        );
      },
    );
  }

  Future<void> updateGender(String gender) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    final trimmed = gender.trim();
    if (trimmed.isEmpty) return;
    emitSafe(current.copyWith(isUpdatingProfile: true));
    final result = await profileRepo.updateProfile(gender: trimmed);
    result.fold(
      (error) {
        PrintUtil.error('profile_gender_update_failed: $error');
        emitSafe(current.copyWith(isUpdatingProfile: false));
      },
      (contact) {
        final updatedUser = contact.data.user;
        globalCubit.updateCachedProfileFromJson(updatedUser.toJson());
        emitSafe(
          current.copyWith(
            profile: updatedUser,
            isUpdatingProfile: false,
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    if (state is! ProfileLoaded) return;
    emitSafe(ProfileLogoutLoading());
    final result = await profileRepo.logout();
    result.fold(
      (error) => emitSafe(ProfileLogoutError(error)),
      (message) async {
        await cacheHelper.removeData(key: AppConstants.userProfile);
        await cacheHelper.removeData(key: AppConstants.token);
        globalCubit.clearCachedProfile();
        emitSafe(ProfileLogoutSuccess(message));
      },
    );
  }

  void setTopic(String? v) {
    topic = v;
    final s = state;
    if (s is ProfileLoaded) emitSafe(s.copyWith());
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

  UserModel _defaultUser() {
    final cached = globalCubit.cachedProfile;
    if (cached != null) {
      return UserModel(
          id: cached.id,
          name: cached.name,
          displayname: cached.displayname,
          email: cached.email,
          mobile: cached.phone,
          imageUrl: cached.avatar,
          membershipId: cached.membershipId,
          userGuid: cached.membershipId,
          roles: const [],
          permissions: const []);
    }
    return const UserModel(
        id: 0,
        name: 'Akram Ahmed',
        email: 'akram.ahmed@share.net.sa',
        mobile: '0540936802',
        imageUrl: "assets/images/png/profile-user.jpg",
        membershipId: 'D-280843',
        userGuid: 'D-280843',
        roles: [],
        permissions: []);
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
