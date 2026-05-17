// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_manachyna_kusa_2_0/app.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ManachynaKusaApp());

    // Verify that the splash screen loads
    expect(
      find.text(
        'DESARROLLO DE APLICACION MOVIL MULTISERVICIO "MANACHYNA KUSA"',
      ),
      findsOneWidget,
    );
    expect(find.text('Servicios del hogar en Napo'), findsOneWidget);
    expect(find.text('Cargando...'), findsOneWidget);
  });

  testWidgets('App shows loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(const ManachynaKusaApp());

    // Verify that loading indicator is present
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
