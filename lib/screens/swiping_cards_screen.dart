import 'dart:math';
import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

// 1. SingleTickerProviderStateMixin 추가
class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _position;

  int _index = 1;

  // 회전 상한과 하한만 지정 (오타 수정: _rotaion → _rotation)
  final Tween<double> _rotation = Tween(begin: -15, end: 15);

  // scale 범위 지정
  final Tween<double> _scale = Tween(begin: 0.8, end: 1);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;

    // 2. AnimationController 생성
    _position = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: (size.width + 100) * -1,
      upperBound: (size.width + 100),
      value: 0.0,
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _position.value += details.delta.dx; // delta : 움직인 양
      // animation Controller 가 기본적으로 가지고 있는 최소/최대 값보다 크면 적용 x
      // 0-1사이 값으로 고정 -> lowercase,uppercase 변경 필요
    });
  }

  void _whenComplete() {
    _position.value = 0; // 카드를 다시 0으로 돌려넣기
    setState(() {
      _index = _index == 5 ? 1 : _index + 1; // 돌려놓은 카드를 이미지 설정 다음 이미지로
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final size = MediaQuery.of(context).size;
    final bound = size.width - 170;
    final dropZone = size.width + 100;

    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(dropZone * factor, curve: Curves.easeOut)
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(0, curve: Curves.easeOut); // 값을 할당하면서 이동 애니메이션
    }
  }

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
          // 화면 정중앙을 첫 앵글 0으로
          final angle = _rotation.transform(
            (_position.value + size.width / 2) / size.width,
          );

          final scale = _scale.transform(_position.value.abs() / size.width);

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // 뒷 카드
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: min(scale, 1.0), // 이미지의 bounce 없애기
                  child: CardWidget(index: _index == 5 ? 1 : _index + 1),
                ),
              ),
              // 앞 카드
              Positioned(
                top: 100,
                child: GestureDetector(
                  // 가로로 드레그 될 때 함수 호출
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle * pi / 180, // angle에 라디안으로 변환
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

// 이름 충돌 방지: Flutter 기본 Card와 겹치지 않도록 CardWidget으로 변경
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
