import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const HomePage(),
    );
  }
}

const double widthHeight = 100;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _animation;

  @override
  void initState() {
    super.initState();

    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );

    _animation = Tween(
      begin: 0.0,
      end: pi * 2,
    );
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: widthHeight, width: double.infinity),
          AnimatedBuilder(
            animation: Listenable.merge([
              _xController,
              _yController,
              _zController,
            ]),
            builder: (BuildContext context, _) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(_animation.evaluate(_xController))
                  ..rotateY(_animation.evaluate(_yController))
                  ..rotateZ(_animation.evaluate(_zController)),
                child: Stack(
                  children: [
                    // back
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..translate(Vector3(0, 0, -widthHeight)),
                      child: Container(
                        color: Colors.purple,
                        height: widthHeight,
                        width: widthHeight,
                      ),
                    ),
                    // left side
                    Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                      ..rotateY(pi / 2),
                      child: Container(
                        color: Colors.red,
                        height: widthHeight,
                        width: widthHeight,
                      ),
                    ),
                    // right side
                    Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()
                        ..rotateY(-pi / 2),
                      child: Container(
                        color: Colors.blue,
                        height: widthHeight,
                        width: widthHeight,
                      ),
                    ),
                    // front
                    Container(
                      color: Colors.green,
                      height: widthHeight,
                      width: widthHeight,
                    ),
                    // top side
                    Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()
                        ..rotateX(-pi / 2),
                      child: Container(
                        color: Colors.deepOrangeAccent,
                        height: widthHeight,
                        width: widthHeight,
                      ),
                    ),
                    Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()
                        ..rotateX(pi / 2),
                      child: Container(
                        color: Colors.brown,
                        height: widthHeight,
                        width: widthHeight,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
