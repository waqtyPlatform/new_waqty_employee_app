import 'package:flutter_test/flutter_test.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/models/login_response_model.dart';

void main() {
  test(
    'LoginResponseModel parses nullable expanded employee payload safely',
    () {
      final model = LoginResponseModel.fromJson({
        'success': true,
        'message': 'ok',
        'data': {
          'access_token': 'abc',
          'token_type': 'Bearer',
          'expires_in': '3600',
          'user': {
            'id': 7,
            'full_name': 'Ahmed',
            'email': null,
            'mobile': '0100',
            'active': 1,
            'blocked': 0,
            'branch': {'id': 3, 'name': 'Main'},
            'extra_field': {'ignored': true},
          },
          'permissions': ['a', 'b'],
        },
      });

      expect(model.token, 'abc');
      expect(model.expiresIn, 3600);
      expect(model.employee.uuid, '7');
      expect(model.employee.email, '');
      expect(model.employee.branch.uuid, '3');
      expect(model.employee.active, isTrue);
      expect(model.employee.blocked, isFalse);
    },
  );

  test('LoginResponseModel handles missing data without throwing', () {
    final model = LoginResponseModel.fromJson({
      'success': false,
      'message': null,
      'data': null,
    });

    expect(model.success, isFalse);
    expect(model.token, '');
    expect(model.employee.branch.name, '');
  });
}
