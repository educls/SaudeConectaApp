import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WaveWidget(
            config: CustomConfig(
              gradients: [
                [Colors.blue, Colors.blue.shade200],
                [Colors.blue.shade200, Colors.blue.shade100],
              ],
              durations: [85000, 19440],
              heightPercentages: [0.10, 0.25],
              blur: MaskFilter.blur(BlurStyle.outer, 10),
              gradientBegin: Alignment.bottomLeft,
              gradientEnd: Alignment.topRight,
            ),
            size: Size(double.infinity, double.infinity),
            waveAmplitude: 0,
          ),
        ],
      ),
    );
  }
}