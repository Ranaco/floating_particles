import 'dart:math';

class Particle {
  double width;
  double height;

  late double r;

  late double dy;
  late double dx;
  late double speedX;
  late double speedY;

  Particle(this.height, this.width) {
    dx = Random().nextDouble() * width;
    dy = Random().nextDouble() * height;

    r = Random().nextDouble() * 10;

    speedX = Random().nextDouble() * 4;
    speedY = Random().nextDouble() * 2.5;
  }
}
