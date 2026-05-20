// Widget test dasar untuk SweetBake
import 'package:flutter_test/flutter_test.dart';
import 'package:sweetbake/providers/cart_provider.dart';
import 'package:sweetbake/main.dart';

void main() {
  testWidgets('SweetBake app smoke test', (WidgetTester tester) async {
    final cartProvider = CartProvider();
    await tester.pumpWidget(MyApp(cartProvider: cartProvider));
    // cukup pastikan app bisa render tanpa crash
    expect(find.byType(MyApp), findsOneWidget);
  });
}
