part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

class LoadingInitData extends OnboardingState {}

class InitDataLoaded extends OnboardingState {
  final String? userType;
  final List<String>? subjects;

  InitDataLoaded({required this.userType, required this.subjects});
}

class NeedUpdate extends OnboardingState {}

class LoadSelectUserPage extends OnboardingState {}

class AccountDeleted extends OnboardingState {}
