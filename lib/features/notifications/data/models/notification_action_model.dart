class NotificationActionModel {
  final String type;
  final String screen;
  final String fallbackScreen;
  final Map<String, dynamic> params;

  const NotificationActionModel({
    required this.type,
    required this.screen,
    required this.fallbackScreen,
    required this.params,
  });

  factory NotificationActionModel.fromJson(Map<String, dynamic> json) {
    return NotificationActionModel(
      type: _asString(json['type'] ?? json['action']),
      screen: _asString(json['screen'] ?? json['target_screen']),
      fallbackScreen: _asString(json['fallback_screen']),
      params: _asMap(json['params']),
    );
  }

  factory NotificationActionModel.fromFlatData(Map<String, dynamic> data) {
    final params = <String, dynamic>{...data};
    return NotificationActionModel(
      type: _asString(data['action'] ?? data['action_type']),
      screen: _asString(data['screen'] ?? data['target_screen']),
      fallbackScreen: _asString(data['fallback_screen']),
      params: params,
    );
  }

  bool get hasScreen => screen.trim().isNotEmpty;
}

String _asString(dynamic value) => value?.toString() ?? '';

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}
