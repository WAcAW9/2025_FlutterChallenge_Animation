import 'dart:math';
import 'package:flutter/material.dart';

class SwipingCardChallenge extends StatefulWidget {
  const SwipingCardChallenge({super.key});

  @override
  State<SwipingCardChallenge> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardChallenge>
    with SingleTickerProviderStateMixin {
  late AnimationController _position;
  int _index = 1;

  final Tween<double> _rotation = Tween(begin: -15, end: 15);
  final Tween<double> _scale = Tween(begin: 0.8, end: 1);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final size = MediaQuery.of(context).size;

    _position = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: (size.width + 100) * -1,
      upperBound: (size.width + 100),
      value: 0.0,
    );
  }

  /// 카드 드래그 중 위치 이동
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _position.value += details.delta.dx;
    });
  }

  /// 카드 이동 애니메이션이 끝난 후 실행
  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  /// 드래그 종료 후 카드의 위치에 따라 다음 동작 결정
  void _onHorizontalDragEnd(DragEndDetails details) {
    final size = MediaQuery.of(context).size;
    final bound = size.width - 170;
    final dropZone = size.width + 100;

    if (_position.value.abs() >= bound) {
      // 바운더리를 넘으면 카드가 화면 밖으로 날아감
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(dropZone * factor, curve: Curves.easeOut)
          .whenComplete(_whenComplete);
    } else {
      // 돌아옴
      _position.animateTo(0, curve: Curves.easeOut);
    }
  }

  void _onCardTap() {}

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Swiping Cards')),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation.transform(
            (_position.value + size.width / 2) / size.width,
          );

          final scale = _scale.transform(_position.value.abs() / size.width);

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // 뒷 카드 (다음 카드)
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: min(scale, 1.0), // bounce 방지
                  child: CardWidget(index: _index == 5 ? 1 : _index + 1),
                ),
              ),
              // 앞 카드 (현재 카드)
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  onTap: _onCardTap,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle * pi / 180,
                      child: CardWidget(index: _index),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final int index;

  const CardWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Image.asset("assets/$index.png", fit: BoxFit.cover),
      ),
    );
  }
}
