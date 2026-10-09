import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pro/main.dart';

void main() {
  testWidgets('app loads login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });
}
