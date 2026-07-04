import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/src/ui/widgets/reveal_on_scroll.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows its child immediately under reduced motion', (
    WidgetTester tester,
  ) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: RevealOnScroll(
                  controller: controller,
                  child: const Text('reveal-child'),
                ),
              );
            },
          ),
        ),
      ),
    );
    // Flush the post-frame reveal check; no animation is scheduled, so a single
    // pump is enough — no settle required.
    await tester.pump();

    // The child renders straight away, not wrapped in a flutter_animate effect.
    expect(find.text('reveal-child'), findsOneWidget);
    expect(find.byType(Animate), findsNothing);
  });
}
