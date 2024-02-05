import 'dart:math';

import 'package:flutter/material.dart';

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
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _counterClockAnimationController;
  late Animation<double> _counterClockwiseAnimation;
  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    // Counter Clockwise animation
    _counterClockAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _counterClockwiseAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(
      CurvedAnimation(
        parent: _counterClockAnimationController,
        curve: Curves.bounceOut,
      ),
    );
    // Flip animation
    _flipAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: _flipAnimationController,
        curve: Curves.bounceOut,
      ),
    );
    // Listeners status
    _counterClockAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(
            parent: _flipAnimationController,
            curve: Curves.bounceOut,
          ),
        );

        // reset the flip controller and start the animation
        _flipAnimationController
          ..reset()
          ..forward();
      }
    });

    _flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseAnimation = Tween<double>(
          begin: _counterClockwiseAnimation.value,
          end: _counterClockwiseAnimation.value + -(pi / 2),
        ).animate(
          CurvedAnimation(
            parent: _counterClockAnimationController,
            curve: Curves.bounceOut,
          ),
        );

        _counterClockAnimationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockAnimationController.dispose();
    _flipAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counterClockAnimationController
      ..reset()
      ..forward.delayed(
        const Duration(seconds: 2),
      );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _counterClockAnimationController,
            builder: (BuildContext context, _) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_counterClockwiseAnimation.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _flipAnimationController,
                      builder: (BuildContext context, _) {
                        return Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()
                            ..rotateY(_flipAnimation.value),
                          child: ClipPath(
                            clipper: HalfCircleClipper(side: CircleSide.left),
                            child: const SizedBox(
                              width: 200,
                              height: 200,
                              child: ColoredBox(color: Colors.tealAccent),
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _flipAnimationController,
                      builder: (BuildContext context, _) {
                        return Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..rotateY(_flipAnimation.value),
                          child: ClipPath(
                            clipper: HalfCircleClipper(side: CircleSide.right),
                            child: const SizedBox(
                              width: 200,
                              height: 200,
                              child: ColoredBox(color: Colors.blueAccent),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) {
    return Future.delayed(duration, this);
  }
}

enum CircleSide {
  left,
  right,
}

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwise,
    );

    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
