import 'package:flutter_test/flutter_test.dart';
import 'package:hope_app/my_app.dart';

void main() {
  testWidgets('HOPE app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('HOPE Rehabilitation'), findsOneWidget);
  });
}
