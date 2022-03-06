import 'package:flutter/material.dart';

class WaveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final lowPoint = size.height / 1.7 - 40;
    final highPoint = size.height / 1.7 - 80;

    path.lineTo(0, size.height / 1.6);
    path.quadraticBezierTo(size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height / 1.7, size.width, lowPoint / 1.2);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double sHeight = size.height / 2;
    path.lineTo(0.0, sHeight - 20);

    var firstControlPoint = Offset(size.width / 4, sHeight);
    var firstEndPoint = Offset(size.width / 2.25, sHeight - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), sHeight - 65);
    var secondEndPoint = Offset(size.width, sHeight - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, sHeight - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
