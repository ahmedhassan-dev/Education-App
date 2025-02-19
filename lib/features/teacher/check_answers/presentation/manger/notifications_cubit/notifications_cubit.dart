import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../../../authentication/data/models/student_notification.dart';
import '../../../../../courses/data/models/courses.dart';
import '../../../domain/repos/check_answers_repo.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.checkAnswersRepo) : super(NotificationsInitial());
  CheckAnswersRepo checkAnswersRepo;

  NotificationModel? notification;
  late Courses course;

  handleCurrentNotification(String studentId, [Courses? course]) async {
    if (course != null) this.course = course;
    await _fetchStudentNotifications(studentId);
    if (notification == null) {
      notification = NotificationModel(
        id: DateTime.now().toIso8601String(),
        studentId: studentId,
        courseId: this.course.id!,
        courseSubject: this.course.subject,
        notificationType: "submission",
        validSolvedProblemsId: [],
        wrongSolvedProblemsId: [],
      );
    } else {
      updateNotificationTimeStamp(notification!.id);
    }
  }

  Future<void> _fetchStudentNotifications(String studentId) async {
    var result =
        await checkAnswersRepo.fetchStudentNotifications(studentId, course.id!);
    result.fold((failure) {
      debugPrint(failure.message);
      emit(NotificationsFailure(errorMsg: failure.message));
    }, (notifications) {
      debugPrint(notifications.toString());
      notification = notifications.isNotEmpty ? notifications.first : null;
      emit(NotificationsLoaded(notifications: notifications));
    });
  }

  Future<void> addStudentNotification() async {
    var result = await checkAnswersRepo.addStudentNotification(notification!);
    result.fold((failure) {
      debugPrint(failure.message);
      emit(NotificationsFailure(errorMsg: failure.message));
    }, (success) {
      emit(NotificationAdded());
    });
  }

  Future<void> updateStudentNotification() async {
    var result =
        await checkAnswersRepo.updateStudentNotification(notification!);
    result.fold((failure) {
      debugPrint(failure.message);
      emit(NotificationsFailure(errorMsg: failure.message));
    }, (success) {
      emit(NotificationUpdated());
    });
  }

  updateNotificationTimeStamp(String notificationId) async {
    await checkAnswersRepo.updateNotificationTimeStamp(notificationId);
  }
}
