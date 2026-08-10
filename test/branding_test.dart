import 'package:dev_garden/presentation/branding/devgarden_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('brand logo uses the official mark, name, and motto', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: BrandLogo())),
    );
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'devGarden. Where ideas grow!',
      ),
      findsOneWidget,
    );
    expect(find.text('devGarden'), findsOneWidget);
    expect(find.text('Where ideas grow!'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == devGardenMarkAsset,
      ),
      findsOneWidget,
    );
  });
}
