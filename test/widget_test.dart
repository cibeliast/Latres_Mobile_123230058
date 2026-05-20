import 'package:flutter_test/flutter_test.dart';
import 'package:nontonskuy/main.dart';

void main() {
  testWidgets('App compiles and loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp(isLoggedIn: false));
    expect(find.byType(MainApp), findsOneWidget);
  });
}
