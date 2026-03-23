abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

// Get Profile States
class GetProfileLoadingState extends ProfileState {}

class GetProfileSuccessState extends ProfileState {
  final String name;
  final String email;
  final String phone;

  GetProfileSuccessState({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class GetProfileErrorState extends ProfileState {}

class GetProfileCatchErrorState extends ProfileState {}

// Update Profile States
class UpdateProfileLoadingState extends ProfileState {}

class UpdateProfileSuccessState extends ProfileState {}

class UpdateProfileErrorState extends ProfileState {}

class UpdateProfileCatchErrorState extends ProfileState {}
