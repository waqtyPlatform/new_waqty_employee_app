abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

// Get Profile States
class GetProfileLoadingState extends ProfileState {}

class GetProfileSuccessState extends ProfileState {}

class GetProfileErrorState extends ProfileState {}

class GetProfileCatchErrorState extends ProfileState {}

class CheckCurrentAttendanceLoadingState extends ProfileState {}

class CheckCurrentAttendanceSuccessState extends ProfileState {}

class CheckCurrentAttendanceErrorState extends ProfileState {}

class CheckCurrentAttendanceCatchErrorState extends ProfileState {}

class AttendanceActionLoadingState extends ProfileState {}

class AttendanceActionSuccessState extends ProfileState {}

class AttendanceActionErrorState extends ProfileState {}

class AttendanceActionCatchErrorState extends ProfileState {}

class PresenceConfirmationLoadingState extends ProfileState {}

class PresenceConfirmationSuccessState extends ProfileState {}

class PresenceConfirmationErrorState extends ProfileState {}

class PresenceConfirmationCatchErrorState extends ProfileState {}

// Update Profile States
class UpdateProfileLoadingState extends ProfileState {}

class UpdateProfileSuccessState extends ProfileState {}

class UpdateProfileErrorState extends ProfileState {}

class UpdateProfileCatchErrorState extends ProfileState {}
