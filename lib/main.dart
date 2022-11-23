import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(GameWidget(game: ChiaProto()));
}

class ChiaProto extends FlameGame
    with HasGameRef, HasKeyboardHandlerComponents {
  @override
  Future<void>? onLoad() {
    add(Chia(radius: 5));
    return super.onLoad();
  }
}

enum Horizontal { left, right }

enum Vertical { up, down }

class Chia extends PositionComponent with KeyboardHandler {
  Chia({required double radius, Paint? paint, Vector2? position})
      : _radius = radius,
        _paint = paint ?? Paint()
          ..color = Colors.white,
        super(
          position: position,
          size: Vector2.all(2 * radius),
          anchor: Anchor.center,
        );

  final double _radius;
  final Paint _paint;

  Horizontal? _horizontal;
  Vertical? _vertical;
  double _speed = 40;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    size.divide(Vector2(2, 2));

    position = size;
  }

  @override
  void update(double dt) {
    double x;
    switch (_horizontal) {
      case Horizontal.left:
        x = -1 * dt * _speed;
        break;
      case Horizontal.right:
        x = 1 * dt * _speed;
        break;
      default:
        x = 0;
    }
    double y;
    switch (_vertical) {
      case Vertical.up:
        y = -1 * dt * _speed;
        break;
      case Vertical.down:
        y = 1 * dt * _speed;
        break;
      default:
        y = 0;
    }
    position += Vector2(x, y);

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final up = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final down = keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final left = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final right = keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (up && !down) {
      _vertical = Vertical.up;
    } else if (down && !up) {
      _vertical = Vertical.down;
    } else if (up && down || !up && !down) {
      _vertical = null;
    }
    if (left && !right) {
      _horizontal = Horizontal.left;
    } else if (right && !left) {
      _horizontal = Horizontal.right;
    } else if (left && right || !left && !right) {
      _horizontal = null;
    }

    return true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(_radius, _radius), _radius, _paint);
  }
}
