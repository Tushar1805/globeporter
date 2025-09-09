// eta_simulator.dart (UI side)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:globeporter/resources/app_colors.dart';

class EtaSimulatorWidget extends StatefulWidget {
  const EtaSimulatorWidget({super.key});

  @override
  State<EtaSimulatorWidget> createState() => _EtaSimulatorWidgetState();
}

class _EtaSimulatorWidgetState extends State<EtaSimulatorWidget> {
  StreamSubscription<int>? _sub;
  final int totalSeconds = 120; // simulate 2 minutes

  void startSimulation() async {
    final service = FlutterBackgroundService();
    await service.startService();

    final stream = Stream<int>.periodic(
      const Duration(seconds: 1),
      (tick) => totalSeconds - tick,
    ).takeWhile((s) => s >= 0);

    _sub?.cancel();
    _sub = stream.listen((remaining) {
      final data = {
        'remaining': remaining,
        'total': totalSeconds,
        'title': 'Driver is coming',
        'body': '${(remaining / 60).floor()}m ${remaining % 60}s left',
      };
      service.invoke('etaUpdate', data);
    }, onDone: () {
      service.invoke('etaUpdate', {
        'remaining': 0,
        'total': totalSeconds,
        'title': 'Arrived',
        'body': 'Driver has arrived',
      });
    });
  }

  void stopSimulation() {
    _sub?.cancel();
    _sub = null;
  }

  @override
  void dispose() {
    stopSimulation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: startSimulation, child: const Text('Start ETA simulation')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: stopSimulation, child: const Text('Stop ETA simulation')),
          ],
        ),
      ),
    );
  }
}
