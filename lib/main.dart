import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'models/particle.dart';

void main(List<String> args) {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FloatingParticle(),
      title: "Floating Particle",
    );
  }
}

class FloatingParticle extends StatefulWidget {
  const FloatingParticle({Key? key}) : super(key: key);

  @override
  State<FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 50));
    particles = [];
    for (var i = 0; i < 10; i++) {
      particles.add(Particle(600, 701));
    }
    update();
    super.initState();
  }

  update() {
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
          onPanUpdate: (e) {
            setState(() {
              particles.add(Particle(600, 701)
                ..dx = e.localPosition.dx
                ..dy = e.localPosition.dy);
            });
          },
          child:
              CustomPaint(painter: ParticleCustomPaint(particles: particles))),
    ));
  }
}

class ParticleCustomPaint extends CustomPainter {
  final List<Particle> particles;

  ParticleCustomPaint({required this.particles});

  double euclidsDistance(Offset p1, Offset p2) {
    double dist = sqrt(pow((p1.dx - p2.dx), 2) + pow((p1.dy - p2.dy), 2));

    return dist;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < particles.length; i++) {
      double dist = 0.0;
      Particle particle = particles[i];

      particle.dx += particle.speedX;
      particle.dy += particle.speedY;

      Paint paint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      if (particle.dx < 0 || particle.dx > size.width) {
        particles[i].speedX *= -1;
      }
      if (particle.dy < 0 || particle.dy > size.height) {
        particles[i].speedY *= -1;
      }
      for (var j = 0; j < particles.length; j++) {
        Particle nxtParticle = particles[j];

        dist = euclidsDistance(Offset(particle.dx, particle.dy),
            Offset(nxtParticle.dx, nxtParticle.dy));

        if (dist < 85) {
          Paint linePaint = Paint()
            ..color = Colors.pink
            ..strokeWidth = 0.5
            ..style = PaintingStyle.stroke;

          canvas.drawLine(Offset(particle.dx, particle.dy),
              Offset(nxtParticle.dx, nxtParticle.dy), linePaint);
        }
      }

      canvas.drawCircle(Offset(particle.dx, particle.dy), particle.r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
