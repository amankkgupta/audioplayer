import 'package:flutter_test/flutter_test.dart';

import 'package:bhagavad_gita_english/main.dart';

void main() {
  testWidgets('app renders splash screen title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Bhagavad Gita English'), findsOneWidget);
  });
}
