import 'dart:async';

import 'package:bloc/bloc.dart';

import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  Future<void> init() async {
    emit(NotificationsLoading());
      await Future.delayed(const Duration(seconds: 2));
    final items = _mock();
    emit(NotificationsLoaded(
      items: items,
      unreadCount:
          items.where((e) => e.status == NotificationStatus.unread).length,
    ));
  }

  void markAsRead(String id) {
    final s = state;
    if (s is NotificationsLoaded) {
      final updated = s.items
          .map((e) =>
              e.id == id ? e.copyWith(status: NotificationStatus.read) : e)
          .toList();
      emit(s.copyWith(
        items: updated,
        unreadCount:
            updated.where((e) => e.status == NotificationStatus.unread).length,
      ));
    }
  }

  void markAllAsRead() {
    final s = state;
    if (s is NotificationsLoaded) {
      final updated = s.items
          .map((e) => e.copyWith(status: NotificationStatus.read))
          .toList();
      emit(s.copyWith(items: updated, unreadCount: 0));
    }
  }

  void setFilter(NotificationType? filter) {
    final s = state;
    if (s is NotificationsLoaded) {
      emit(s.copyWith(filter: filter));
    }
  }

  List<NotificationItem> _mock() {
    return [
      NotificationItem(
        id: '1',
        title: 'تم استلام تبرعك',
        body: 'شكرًا لدعمك، رقم العملية BIR-060278',
        timeLabel: 'قبل دقيقة',
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
        type: NotificationType.text,
        status: NotificationStatus.unread,
      ),
      NotificationItem(
        id: '2',
        title: 'فاتورة جديدة',
        body: 'تم إصدار فاتورة بمبلغ 1500',
        timeLabel: 'قبل 10 دقائق',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        type: NotificationType.bill,
        status: NotificationStatus.warning,
      ),
      NotificationItem(
        id: '3',
        title: 'خبر جديد',
        body: 'شهادة تكامل لجمعية البر بجدة',
        timeLabel: 'اليوم',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.news,
        status: NotificationStatus.info,
      ),
      NotificationItem(
        id: '4',
        title: 'تذكير بالاستقطاع',
        body: 'موعد استقطاعك الدوري غدًا',
        timeLabel: 'أمس',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.reminder,
        status: NotificationStatus.unread,
      ),
      NotificationItem(
        id: '5',
        title: 'تم تحديث الملف الشخصي',
        body: 'تم حفظ تعديلاتك بنجاح',
        timeLabel: 'منذ 3 أيام',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.system,
        status: NotificationStatus.success,
      ),
      NotificationItem(
        id: '6',
        title: 'فشل الدفع',
        body: 'حدث خطأ أثناء معالجة العملية',
        timeLabel: 'الآن',
        createdAt: DateTime.now(),
        type: NotificationType.system,
        status: NotificationStatus.error,
      ),
    ];
  }
}
