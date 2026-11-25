import 'package:flutter/material.dart';

import 'data/todo_repository.dart';
import 'screens/todo_screen.dart';
import 'state/todo_state.dart';

void main() {
  final state = TodoState(TodoRepository());
  runApp(TodoApp(state: state));
}

class TodoApp extends StatelessWidget {
  final TodoState state;

  const TodoApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF1C1C1E);
    const panel = Color(0xFF2C2C2E);
    const control = Color(0xFF4A4A4F);
    const orange = Color(0xFFFF9F0A);
    const corners = BorderRadius.all(Radius.circular(6));
    const shape = RoundedRectangleBorder(borderRadius: corners);
    const fieldBorder = OutlineInputBorder(
      borderRadius: corners,
      borderSide: BorderSide.none,
    );

    return MaterialApp(
      title: 'Список задач',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: orange,
          onPrimary: Colors.black,
          secondaryContainer: orange,
          onSecondaryContainer: Colors.black,
          surface: background,
          onSurfaceVariant: Color(0xFFD4D4D8),
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(backgroundColor: background),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel,
          border: fieldBorder,
          enabledBorder: fieldBorder,
          focusedBorder: fieldBorder.copyWith(
            borderSide: const BorderSide(color: orange, width: 2),
          ),
        ),
        cardTheme: const CardThemeData(
          color: panel,
          elevation: 0,
          shape: shape,
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: control,
          shape: shape,
          side: BorderSide.none,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: shape,
            minimumSize: const Size(0, 48),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: orange,
          foregroundColor: Colors.black,
          shape: shape,
        ),
      ),
      builder: (context, child) => ColoredBox(
        color: background,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ),
      home: TodoScreen(state: state),
    );
  }
}
