part of 'notifications_cubit.dart';

@immutable
sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsFailure extends NotificationsState {
  final String errorMsg;
  NotificationsFailure({required this.errorMsg});
}

final class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  NotificationsLoaded({required this.notifications});
}

final class NotificationAdded extends NotificationsState {}

final class NotificationUpdated extends NotificationsState {}
