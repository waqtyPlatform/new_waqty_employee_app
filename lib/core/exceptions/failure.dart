import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String code;
  final Map<String, dynamic> meta;

  const Failure({required this.message, this.code = '', this.meta = const {}});

  @override
  List<Object> get props => [message, code, meta];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code = '',
    super.meta = const {},
  });

  factory ServerFailure.fromJson(Map<String, dynamic> json) {
    return ServerFailure(
      message: _message(json),
      code: json['code']?.toString() ?? '',
      meta: _asMap(json['meta']),
    );
  }
}

String _message(Map<String, dynamic> json) {
  final errors = json['errors'];
  if (errors is Map) {
    for (final value in errors.values) {
      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }
      if (value != null) return value.toString();
    }
  }
  return json['message']?.toString() ?? 'Server error';
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const {};
}
