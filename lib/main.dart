// App-Einstiegspunkt: MultiProvider um MaterialApp (Referenzmuster aus
// spraytattoo_katalog), `home:` ist ein Init-Gate, das die drei Services
// lädt (Sprache/Schläger/Runden) und währenddessen einen kurzen
// Splash zeigt.
//
// Achtung Test-Stolperfalle (siehe PFLICHTENHEFT.md / Standard Abschnitt 5):
// `tester.pumpAndSettle()` wartet NICHT automatisch auf den reinen
// `Future.delayed`-Timer der Mindest-Splashdauer – Tests, die den App-Root
// berühren, müssen zusätzlich `await tester.pump(_splashMinDuration);`
// vor `pumpAndSettle()` aufrufen.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/start_screen.dart';
import 'services/clubs_service.dart';
import 'services/locale_service.dart';
import 'services/rounds_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GcwbbApp());
}

class GcwbbApp extends StatelessWidget {
  const GcwbbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(create: (_) => ClubsService()),
        ChangeNotifierProvider(create: (_) => RoundsService()),
      ],
      child: MaterialApp(
        title: 'GC Winterberg Birdie Book',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const _InitGate(),
      ),
    );
  }
}

/// Mindest-Anzeigedauer des Splash, damit der Wechsel nicht flackert, auch
/// wenn `SharedPreferences` sehr schnell antwortet.
const Duration _splashMinDuration = Duration(milliseconds: 500);

class _InitGate extends StatefulWidget {
  const _InitGate();

  @override
  State<_InitGate> createState() => _InitGateState();
}

class _InitGateState extends State<_InitGate> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final locale = context.read<LocaleService>();
    final clubs = context.read<ClubsService>();
    final rounds = context.read<RoundsService>();
    await Future.wait([
      locale.load(),
      clubs.load(),
      rounds.load(),
      Future.delayed(_splashMinDuration),
    ]);
    if (!mounted) return;
    setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const _SplashScreen();
    }
    return const StartScreen();
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.golf_course, size: 56),
            SizedBox(height: 16),
            Text('GC Winterberg Birdie Book'),
          ],
        ),
      ),
    );
  }
}
