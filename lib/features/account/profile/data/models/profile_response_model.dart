class ProfileResponseModel {
  final ProfileCustomer customer;

  ProfileResponseModel({required this.customer});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      customer: ProfileCustomer.fromJson(json['data']),
    );
  }
}

class ProfileCustomer {
  final String uuid;
  final String name;
  final String phone;
  final String email;
  final bool active;
  final bool blocked;
  final BranchModel branchModel;

  ProfileCustomer({
    required this.uuid,
    required this.name,
    required this.phone,
    required this.email,
    required this.active,
    required this.blocked,
    required this.branchModel,
  });

  factory ProfileCustomer.fromJson(Map<String, dynamic> json) {
    return ProfileCustomer(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      active: json['active'] ?? true,
      blocked: json['blocked'] ?? false,
      branchModel: BranchModel.fromJson(json['branch']),
    );
  }
}

class BranchModel {
  final String uuid;
  final String name;

  BranchModel({required this.uuid, required this.name});

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(uuid: json['uuid'] ?? '', name: json['name'] ?? '');
  }
}
