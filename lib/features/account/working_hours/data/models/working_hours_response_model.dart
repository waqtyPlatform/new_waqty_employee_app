class WorkingHoursResponseModel {
  final bool success;
  final List<WorkingHoursModel> data;
  final Meta meta;

  WorkingHoursResponseModel({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory WorkingHoursResponseModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursResponseModel(
      success: json['success'] ?? false,
      data: (json['data'] as List?)
              ?.map((e) => WorkingHoursModel.fromJson(e))
              .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }
}

class WorkingHoursModel {
  final String uuid;
  final String shiftDate;
  final String startTime;
  final String endTime;
  final String? breakStart;
  final String? breakEnd;
  final bool active;
  final Shift shift;
  final Branch branch;
  final Provider provider;

  WorkingHoursModel({
    required this.uuid,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    this.breakStart,
    this.breakEnd,
    required this.active,
    required this.shift,
    required this.branch,
    required this.provider,
  });

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      uuid: json['uuid'] ?? '',
      shiftDate: json['shift_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      breakStart: json['break_start'],
      breakEnd: json['break_end'],
      active: json['active'] ?? false,
      shift: Shift.fromJson(json['shift'] ?? {}),
      branch: Branch.fromJson(json['branch'] ?? {}),
      provider: Provider.fromJson(json['provider'] ?? {}),
    );
  }
}

class Shift {
  final String uuid;
  final String title;
  final String? notes;

  Shift({
    required this.uuid,
    required this.title,
    this.notes,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      uuid: json['uuid'] ?? '',
      title: json['title'] ?? '',
      notes: json['notes'],
    );
  }
}

class Branch {
  final String uuid;
  final String name;

  Branch({
    required this.uuid,
    required this.name,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Provider {
  final String uuid;
  final String name;

  Provider({
    required this.uuid,
    required this.name,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Meta {
  final Pagination pagination;

  Meta({required this.pagination});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Pagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  Pagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }
}
