import 'package:flutter_test/flutter_test.dart';
import 'package:project_api/validators.dart';

void main() {
  group('Username validity test', () {
    test('empty name input return error message', () {
      var result = ValidateEntries().validateUsername('');
      expect(result, 'Enter valid Name');
    });

    test('name length less that 3 letters error message', () {
      var result = ValidateEntries().validateUsername('La');
      expect(result, 'Enter valid Name');
    });

    test('valid username return null', () {
      var result = ValidateEntries().validateUsername('Hans Thisanke');
      expect(result, null);
    });
  });

  group('Age validity test', () {
    test('Unacceptable age gives error message', () {
      var result = ValidateEntries().validateUserAge('10');
      expect(result, 'Enter Valid age');
    });

    test('Acceptable age return null', () {
      var result = ValidateEntries().validateUserAge('30');
      expect(result, null);
    });
  });

  group('Contact number validity test', () {
    test('Contain non numerics gives error message', () {
      var result = ValidateEntries().validateUserContact('07^3789891');
      expect(result, 'Enter valid contact Number');
    });

    test('A 10 digit number start with 07 return null', () {
      var result = ValidateEntries().validateUserContact('0712345781');
      expect(result, null);
    });
  });

  group('Device serialNo validity test', () {
    test('Invalid Mac Address length gives error', () {
      var result = ValidateEntries().validateDeviceSerialNo('82:19:D4:6E');
      expect(result, 'Enter a valid Serial');
    });

    test('Acceptable serial number return null', () {
      var result =
          ValidateEntries().validateDeviceSerialNo('82:56:G8:56:8A:34');
      expect(result, null);
    });
  });
}
