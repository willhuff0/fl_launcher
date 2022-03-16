import 'package:flutter/material.dart';
import 'package:minecraft_launcher/ui/setup/setup.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

class SetupLanding extends StatelessWidget {
  const SetupLanding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ParallaxStack(
          resetOnExit: false,
          layers: [
            ParallaxLayer(
              yRotation: 0.3,
              xRotation: 0.3,
              xOffset: 60,
              yOffset: 60,
              child: Center(
                child: Material(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(width: 275, height: 150),
                ),
              ),
            ),
            ParallaxLayer(
              yRotation: 0.4,
              xRotation: 0.4,
              xOffset: 20,
              yOffset: 20,
              child: Center(
                child: Material(
                  color: Colors.grey.shade900.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('fl_launcher', style: TextStyle(fontSize: 36)),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 48.0,
          right: 48.0,
          child: TextButton(
            child: Text('Next'),
            onPressed: () => setupNextPage(),
          ),
        ),
      ],
    );
  }
}