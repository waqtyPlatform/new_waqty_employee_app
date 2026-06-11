class BranchContactResponseModel {
  final bool success;
  final BranchContactModel? data;

  BranchContactResponseModel({required this.success, required this.data});

  factory BranchContactResponseModel.fromJson(Map<String, dynamic> json) {
    return BranchContactResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? BranchContactModel.fromJson(json['data'])
          : null,
    );
  }
}

class BranchContactModel {
  final String uuid;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final double? latitude;
  final double? longitude;

  BranchContactModel({
    required this.uuid,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory BranchContactModel.fromJson(Map<String, dynamic> json) {
    return BranchContactModel(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
