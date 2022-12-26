import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

class MainArea extends StatefulWidget {
  const MainArea({super.key});

  @override
  State<MainArea> createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  bool top = false, bottom = true, left = false, right = true;

  late final StreamSubscription<SensorEvent> _sensor;
  double dx = 0;
  double dy = 0;
  double dif = 2;

  init() async {
    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.GYROSCOPE,
      interval: Sensors.SENSOR_DELAY_GAME,
    );
    _sensor = stream.listen((sensorEvent) {
      final l = sensorEvent.data;
      dy += l[0];
      dx += l[1];
      setState(() {
        right = (dx > dif);
        left = (dx < -dif);
        bottom = (dy > dif);
        top = (dy < -dif);

        deg = 44 + min(45, dx.abs()) - min(45, dy.abs());
        size = 8 + min(max(dx.abs(), dy.abs()) * 6, 180);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  // degrees to radians
  double degToRad(double deg) {
    return deg * (pi / 180);
  }

  double sinToDeg(double sin) {
    return sin * (180 / pi);
  }

  double deg = 65;
  double size = 6;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width, h = mq.size.height, p = mq.padding;

    double vSkew = (top || bottom) ? (top ? 1.2 : -1) : 0;
    if (left && top) vSkew += -0.03;
    //if (left) vSkew += 0.2;
    double hSkew = (left || right) ? (0.57 * (left ? -1 : 1)) : 0;
    double pl = (left || right) ? ((w * 0.2) * (left ? 1 : -1)) : 0;
    double hSide = h * 0.1;
    double wSide = w * 0.1;

    double lr = left ? 1 : -1;
    double tb = top ? 1 : -1;

    return Stack(children: [
      if (top)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Transform(
            transform: Matrix4.skewX((left || right) ? degToRad(deg * lr) : 0),
            child: Container(
              color: Colors.red,
              height: cos(degToRad(deg)) * size,
            ),
          ),
        ),
      if (left)
        Positioned(
          top: 0,
          left: 0,
          height: h,
          child: Transform(
            transform: Matrix4.skewY(
              (top || bottom) ? degToRad(90 - deg) * tb : 0,
            ),
            child: Container(
              color: Colors.yellow,
              width: sin(degToRad(deg)) * size,
            ),
          ),
        ),
      Positioned(
        top: top ? cos(degToRad(deg)) * size : 0,
        left: left ? sin(degToRad(deg)) * size : 0,
        right: right ? sin(degToRad(deg)) * size : 0,
        bottom: bottom ? cos(degToRad(deg)) * size : 0,
        child: InkWell(
          onTap: () {
            setState(() {
              top = false;
              bottom = false;
              left = false;
              right = false;
              dx = 0;
              dy = 0;
            });
          },
          child: Container(
            color: Colors.blue,
          ),
        ),
      ),
      if (right)
        Positioned(
          top: (top || bottom) ? tb * cos(degToRad(deg)) * size : 0,
          right: 0,
          height: h,
          child: Transform(
            transform: Matrix4.skewY(
              (top || bottom) ? degToRad(90 - deg) * -tb : 0,
            ),
            child: Container(
              color: Colors.green,
              width: sin(degToRad(deg)) * size,
            ),
          ),
        ),
      if (bottom)
        Positioned(
          bottom: 0,
          width: w,
          right: right ? (sin(degToRad(deg)) * size) : null,
          left: left ? (sin(degToRad(deg)) * size) : null,
          child: Transform(
            transform: Matrix4.skewX((left || right) ? degToRad(deg * -lr) : 0),
            child: Container(
              color: Colors.purple,
              height: cos(degToRad(deg)) * size,
            ),
          ),
        ),
      /*
        Positioned(
          child: Center(
            child: _buildCtrl(),
          ),
        ),
        */
    ]);
  }

  _buildCtrl() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey,
      child: Column(
        children: [
          Row(children: [
            IconButton(
              onPressed: () {
                setState(() {
                  top = true;
                  bottom = false;
                  left = true;
                  right = false;
                });
              },
              icon: const Icon(Icons.north_west),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  top = true;
                  bottom = false;
                  left = false;
                  right = false;
                });
              },
              icon: const Icon(Icons.north),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  top = true;
                  bottom = false;
                  left = false;
                  right = true;
                });
              },
              icon: const Icon(Icons.north_east),
            ),
          ]),
          Row(children: [
            IconButton(
              onPressed: () {
                setState(() {
                  top = false;
                  bottom = false;
                  left = true;
                  right = false;
                });
              },
              icon: const Icon(Icons.west),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  top = false;
                  bottom = false;
                  left = false;
                  right = false;
                });
              },
              icon: const Icon(Icons.center_focus_strong),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  top = false;
                  bottom = false;
                  left = false;
                  right = true;
                });
              },
              icon: const Icon(Icons.east),
            ),
          ]),
          Row(children: [
            IconButton(
              onPressed: () {
                setState(() {
                  top = false;
                  bottom = true;
                  left = true;
                  right = false;
                });
              },
              icon: const Icon(Icons.south_west),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  top = false;
                  bottom = true;
                  left = false;
                  right = false;
                });
              },
              icon: const Icon(Icons.south),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  top = false;
                  bottom = true;
                  left = false;
                  right = true;
                });
              },
              icon: const Icon(Icons.south_east),
            ),
          ]),
        ],
      ),
    );
  }
}
