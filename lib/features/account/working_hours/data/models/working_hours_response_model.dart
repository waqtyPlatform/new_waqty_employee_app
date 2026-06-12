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
      data:
          (json['data'] as List?)
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
  final int? plannedMinutes;
  final double? plannedHours;
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
    this.plannedMinutes,
    this.plannedHours,
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
      plannedMinutes: _parseInt(json['planned_minutes']),
      plannedHours: _parseDouble(json['planned_hours']),
      shift: Shift.fromJson(json['shift'] ?? {}),
      branch: Branch.fromJson(json['branch'] ?? {}),
      provider: Provider.fromJson(json['provider'] ?? {}),
    );
  }

  int get shiftMinutes => _durationMinutes(startTime, endTime);

  int get breakMinutes {
    if (breakStart == null || breakEnd == null) {
      return 0;
    }
    return _durationMinutes(breakStart!, breakEnd!);
  }

  int get netMinutes =>
      plannedMinutes ??
      (plannedHours != null ? (plannedHours! * 60).round() : null) ??
      (shiftMinutes - breakMinutes).clamp(0, shiftMinutes).toInt();
}

int? _parseInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.round();
  }
  return int.tryParse(value.toString());
}

double? _parseDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value.toString());
}

int _durationMinutes(String start, String end) {
  final startMinutes = _timeToMinutes(start);
  final endMinutes = _timeToMinutes(end);
  if (startMinutes == null || endMinutes == null) {
    return 0;
  }
  final duration = endMinutes - startMinutes;
  return duration < 0 ? duration + (24 * 60) : duration;
}

int? _timeToMinutes(String value) {
  final parts = value.split(':');
  if (parts.length < 2) {
    return null;
  }
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) {
    return null;
  }
  return (hour * 60) + minute;
}

class Shift {
  final String uuid;
  final String title;
  final String? notes;

  Shift({required this.uuid, required this.title, this.notes});

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

  Branch({required this.uuid, required this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(uuid: json['uuid'] ?? '', name: json['name'] ?? '');
  }
}

class Provider {
  final String uuid;
  final String name;

  Provider({required this.uuid, required this.name});

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(uuid: json['uuid'] ?? '', name: json['name'] ?? '');
  }
}

class Meta {
  final Pagination pagination;

  Meta({required this.pagination});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(pagination: Pagination.fromJson(json['pagination'] ?? {}));
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
    final int perPage = json['per_page'] ?? 15;
    final int total = json['total'] ?? 0;
    final calculatedLastPage = perPage > 0 ? (total / perPage).ceil() : 1;

    return Pagination(
      currentPage: json['current_page'] ?? 1,
      perPage: perPage,
      total: total,
      lastPage: calculatedLastPage > 0
          ? calculatedLastPage
          : json['last_page'] ?? 1,
    );
  }
}
