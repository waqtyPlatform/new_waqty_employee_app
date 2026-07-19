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
  final int? dayOfWeek;
  final String dayName;
  final String startTime;
  final String endTime;
  final String? breakStart;
  final String? breakEnd;
  final bool active;
  final bool isDayOff;
  final int? apiShiftMinutes;
  final double? apiShiftHours;
  final int? apiBreakMinutes;
  final double? apiBreakHours;
  final int? apiNetMinutes;
  final double? apiNetHours;
  final int? plannedMinutes;
  final double? plannedHours;
  final List<WorkingHoursPeriod> periods;
  final Shift shift;
  final Branch branch;
  final Provider provider;

  WorkingHoursModel({
    required this.uuid,
    required this.shiftDate,
    this.dayOfWeek,
    required this.dayName,
    required this.startTime,
    required this.endTime,
    this.breakStart,
    this.breakEnd,
    required this.active,
    required this.isDayOff,
    this.apiShiftMinutes,
    this.apiShiftHours,
    this.apiBreakMinutes,
    this.apiBreakHours,
    this.apiNetMinutes,
    this.apiNetHours,
    this.plannedMinutes,
    this.plannedHours,
    required this.periods,
    required this.shift,
    required this.branch,
    required this.provider,
  });

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      uuid: json['uuid'] ?? '',
      shiftDate: json['shift_date'] ?? '',
      dayOfWeek: _parseInt(json['day_of_week']),
      dayName: json['day_name']?.toString() ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      breakStart: json['break_start'],
      breakEnd: json['break_end'],
      active: json['active'] ?? false,
      isDayOff: json['is_day_off'] ?? false,
      apiShiftMinutes: _parseInt(json['shift_minutes']),
      apiShiftHours: _parseDouble(json['shift_hours']),
      apiBreakMinutes: _parseInt(json['break_minutes']),
      apiBreakHours: _parseDouble(json['break_hours']),
      apiNetMinutes: _parseInt(json['net_minutes']),
      apiNetHours: _parseDouble(json['net_hours']),
      plannedMinutes: _parseInt(json['planned_minutes']),
      plannedHours: _parseDouble(json['planned_hours']),
      periods:
          (json['periods'] as List?)
              ?.map((e) => WorkingHoursPeriod.fromJson(e))
              .toList() ??
          [],
      shift: Shift.fromJson(json['shift'] ?? {}),
      branch: Branch.fromJson(json['branch'] ?? {}),
      provider: Provider.fromJson(json['provider'] ?? {}),
    );
  }

  String get expandKey => '$uuid-$shiftDate';

  int get shiftMinutes =>
      apiShiftMinutes ??
      (apiShiftHours != null ? (apiShiftHours! * 60).round() : null) ??
      _durationMinutes(startTime, endTime);

  int get breakMinutes {
    if (apiBreakMinutes != null) {
      return apiBreakMinutes!;
    }
    if (apiBreakHours != null) {
      return (apiBreakHours! * 60).round();
    }
    if (breakStart == null || breakEnd == null) {
      return 0;
    }
    return _durationMinutes(breakStart!, breakEnd!);
  }

  int get netMinutes =>
      apiNetMinutes ??
      (apiNetHours != null ? (apiNetHours! * 60).round() : null) ??
      plannedMinutes ??
      (plannedHours != null ? (plannedHours! * 60).round() : null) ??
      (shiftMinutes - breakMinutes).clamp(0, shiftMinutes).toInt();
}

class WorkingHoursPeriod {
  final String startTime;
  final String endTime;
  final bool endsNextDay;
  final int shiftMinutes;
  final int breakMinutes;
  final int netMinutes;

  WorkingHoursPeriod({
    required this.startTime,
    required this.endTime,
    required this.endsNextDay,
    required this.shiftMinutes,
    required this.breakMinutes,
    required this.netMinutes,
  });

  factory WorkingHoursPeriod.fromJson(Map<String, dynamic> json) {
    return WorkingHoursPeriod(
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      endsNextDay: json['ends_next_day'] ?? false,
      shiftMinutes: _parseInt(json['shift_minutes']) ?? 0,
      breakMinutes: _parseInt(json['break_minutes']) ?? 0,
      netMinutes: _parseInt(json['net_minutes']) ?? 0,
    );
  }
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
    final int perPage = _parseInt(json['per_page']) ?? 15;
    final int total = _parseInt(json['total']) ?? 0;
    final calculatedLastPage = perPage > 0 ? (total / perPage).ceil() : 1;

    return Pagination(
      currentPage: _parseInt(json['current_page']) ?? 1,
      perPage: perPage,
      total: total,
      lastPage: calculatedLastPage > 0
          ? calculatedLastPage
          : _parseInt(json['last_page']) ?? 1,
    );
  }
}
