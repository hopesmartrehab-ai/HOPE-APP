import 'package:flutter_test/flutter_test.dart';
import 'package:hope_app/main.dart';

void main() {
  testWidgets('HOPE app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HopeApp());
    expect(find.text('HOPE Rehabilitation'), findsOneWidget);
  });
}
