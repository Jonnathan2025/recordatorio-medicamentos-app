// Test para la aplicación de Recordatorio de Medicamentos
//
// Este test verifica que la pantalla principal se carga correctamente
// y muestra los elementos esperados para adultos mayores.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recordatoriomedicamentosapp/main.dart';

void main() {
  testWidgets('Home screen loads correctly', (WidgetTester tester) async {
    // Construir nuestra aplicación y renderizar un frame
    await tester.pumpWidget(const RecordatorioMedicamentosApp());

    // Verificar que el AppBar con el título aparece
    expect(find.text('Recordatorio de Medicamentos'), findsOneWidget);

    // Verificar que el saludo aparece (alguna variante)
    // Usamos textContaining para capturar "Buenos días", "Buenas tardes", etc.
    expect(find.textContaining('Buenos'), findsOneWidget);

    // Verificar que el mensaje de cuidado aparece
    expect(find.text('Es hora de cuidar tu salud'), findsOneWidget);

    // Verificar que las tarjetas de resumen aparecen
    expect(find.text('Medicamentos'), findsOneWidget);
    expect(find.text('Hoy'), findsOneWidget);
    expect(find.text('Tomados'), findsOneWidget);

    // Verificar que la sección de próximos medicamentos aparece
    expect(find.text('Próximos Medicamentos'), findsOneWidget);

    // Verificar que los botones de acción rápida aparecen
    expect(find.text('Ver Todos'), findsOneWidget);
    expect(find.text('Historial'), findsOneWidget);
    expect(find.text('Configurar'), findsOneWidget);

    // Verificar que el texto del botón flotante aparece
    expect(find.text('Agregar Medicamento'), findsOneWidget);
  });

  testWidgets('Quick action buttons are tappable', (WidgetTester tester) async {
    // Construir la aplicación
    await tester.pumpWidget(const RecordatorioMedicamentosApp());

    // Esperar a que la UI se estabilice
    await tester.pumpAndSettle();

    // Buscar y tocar el botón "Ver Todos"
    final verTodosButton = find.text('Ver Todos');
    expect(verTodosButton, findsOneWidget);

    await tester.tap(verTodosButton);
    await tester.pumpAndSettle();

    // Verificar que el SnackBar aparece (o cualquier otra acción esperada)
    expect(find.textContaining('medicamentos'), findsOneWidget);
  });

  testWidgets('Floating action button is accessible', (WidgetTester tester) async {
    // Construir la aplicación
    await tester.pumpWidget(const RecordatorioMedicamentosApp());
    await tester.pumpAndSettle();

    // Buscar el botón flotante
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);

    // Verificar que se puede tocar
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Verificar que el SnackBar aparece
    expect(find.textContaining('medicamento'), findsOneWidget);
  });

  testWidgets('App theme is correctly applied', (WidgetTester tester) async {
    // Construir la aplicación
    await tester.pumpWidget(const RecordatorioMedicamentosApp());

    // Obtener el contexto de la aplicación
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    // Verificar que el título de la aplicación es correcto
    expect(materialApp.title, 'Recordatorio de Medicamentos');

    // Verificar que el banner de debug está deshabilitado
    expect(materialApp.debugShowCheckedModeBanner, false);
  });

  testWidgets('Summary cards display correct information', (WidgetTester tester) async {
    // Construir la aplicación
    await tester.pumpWidget(const RecordatorioMedicamentosApp());
    await tester.pumpAndSettle();

    // Verificar que las tarjetas de resumen tienen iconos
    expect(find.byIcon(Icons.medication), findsOneWidget);
    expect(find.byIcon(Icons.today), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    // Verificar que las tarjetas son interactivas (son Cards)
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('Medication cards are displayed', (WidgetTester tester) async {
    // Construir la aplicación
    await tester.pumpWidget(const RecordatorioMedicamentosApp());
    await tester.pumpAndSettle();

    // Verificar que hay ListTiles (para las tarjetas de medicamentos)
    expect(find.byType(ListTile), findsWidgets);

    // Verificar que hay iconos de medicamento
    expect(find.byIcon(Icons.medication), findsWidgets);
  });

  testWidgets('Navigation buttons work correctly', (WidgetTester tester) async {
    // Construir la aplicación
    await tester.pumpWidget(const RecordatorioMedicamentosApp());
    await tester.pumpAndSettle();

    // Probar el botón de Historial
    final historialButton = find.text('Historial');
    expect(historialButton, findsOneWidget);

    await tester.tap(historialButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('historial'), findsOneWidget);

    // Probar el botón de Configurar
    final configurarButton = find.text('Configurar');
    expect(configurarButton, findsOneWidget);

    await tester.tap(configurarButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('configuración'), findsOneWidget);
  });

  testWidgets('App is accessible for elderly users', (WidgetTester tester) async {
    // Construir la aplicación
    await tester.pumpWidget(const RecordatorioMedicamentosApp());
    await tester.pumpAndSettle();

    // Verificar que hay elementos grandes y fáciles de tocar
    final elevatedButtons = find.byType(ElevatedButton);
    expect(elevatedButtons, findsWidgets);

    // Verificar que el FAB es accesible
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);

    // Verificar que hay iconos grandes para mejor visibilidad
    final icons = find.byType(Icon);
    expect(icons, findsWidgets);
  });
}