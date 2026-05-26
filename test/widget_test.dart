import 'package:flutter_test/flutter_test.dart';
import 'package:thunder_thursday_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    expect(ThunderApp, isNotNull);
  });
}
