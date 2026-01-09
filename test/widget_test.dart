import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    // Mock initial values for SharedPreferences
    SharedPreferences.setMockInitialValues({'isFirstTime': true});
  });

  test('SharedPreferences mock test', () async {
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('isFirstTime'), true);
  });
}
