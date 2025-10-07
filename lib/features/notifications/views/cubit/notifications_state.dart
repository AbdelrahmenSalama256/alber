import 'package:flutter/material.dart';

enum NotificationType { text, bill, news, reminder, system }

enum NotificationStatus { unread, read, warning, info, success, error }

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationItem> items;
  final int unreadCount;
  final NotificationType? filter;
  NotificationsLoaded({
    required this.items,
    required this.unreadCount,
    this.filter,
  });
  NotificationsLoaded copyWith({
    List<NotificationItem>? items,
    int? unreadCount,
    NotificationType? filter,
  }) {
    return NotificationsLoaded(
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      filter: filter ?? this.filter,
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String timeLabel;
  final DateTime createdAt;
  final NotificationType type;
  final NotificationStatus status;
  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.createdAt,
    required this.type,
    required this.status,
  });
  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    String? timeLabel,
    DateTime? createdAt,
    NotificationType? type,
    NotificationStatus? status,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timeLabel: timeLabel ?? this.timeLabel,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}

Color statusColor(NotificationStatus s) {
  switch (s) {
    case NotificationStatus.read:
      return Colors.green;
    case NotificationStatus.unread:
      return Colors.red;
    case NotificationStatus.warning:
      return Colors.orange;
    case NotificationStatus.info:
      return Colors.blue;
    case NotificationStatus.success:
      return const Color(0xFF2E7D32);
    case NotificationStatus.error:
      return const Color(0xFFC62828);
  }
}
