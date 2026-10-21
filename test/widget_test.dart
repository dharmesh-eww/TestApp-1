import 'package:flutter_test/flutter_test.dart';
import 'package:biodata/main.dart';

void main() {
  testWidgets('App renders splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BiodataApp());

    expect(find.text('Marriage Biodata'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
