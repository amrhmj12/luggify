
import 'package:flutter_test/flutter_test.dart';
import 'package:luggify/main.dart';

void main() {
  testWidgets('Luggify app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const LuggifyApp());

    expect(find.text('Luggify'), findsWidgets);
    expect(find.text('Welcome to Luggify!'), findsOneWidget);
  });
}
