import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fl_launcher/main.dart';

class SetupDone extends StatefulWidget {
  const SetupDone({Key? key}) : super(key: key);

  @override
  State<SetupDone> createState() => _SetupDoneState();
}

class _SetupDoneState extends State<SetupDone> {
  late ConfettiController _controller;

  @override
  void initState() {
    _controller = ConfettiController(duration: Duration(seconds: 1));
    Future.delayed(Duration(milliseconds: 500)).then((value) => setState(() => _controller.play()));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.05,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple], // manually specify the colors to be used
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Start fl_launcher', style: TextStyle(fontSize: 16.0)),
              ),
              onPressed: () => refreshApp(),
            ),
          ),
        )
      ],
    );
  }
}
