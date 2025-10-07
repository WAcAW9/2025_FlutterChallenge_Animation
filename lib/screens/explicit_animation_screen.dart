import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ExplicitAnimationScreen extends StatefulWidget {
  const ExplicitAnimationScreen({super.key});

  @override
  State<ExplicitAnimationScreen> createState() =>
      _ExplicitAnimationScreenState();
}

class _ExplicitAnimationScreenState extends State<ExplicitAnimationScreen>
    with SingleTickerProviderStateMixin {
  // with SingleTickerProviderStateMixin 추가하기

  late final AnimationController _animationController =
      AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
        reverseDuration: Duration(seconds: 3),
      )..addListener(() {
        // vlaue 값을 리슨
        _range.value = _animationController.value;
      });

  // boxDecroation tewwn 생성
  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(20),
    ),
    end: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(120),
    ),
  ).animate(_curved); // _curved로 애니메이션을 만들어줌

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 1.2,
  ).animate(_curved);

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_curved);

  late final Animation<Offset> _position = Tween(
    begin: Offset.zero,
    end: Offset(0, -0.2),
  ).animate(_curved);

  // // _curved 만들기
  late final CurvedAnimation _curved = CurvedAnimation(
    parent: _animationController, // 애니메이션 컨트롤러와 직접 연결
    curve: Curves.elasticOut,
    reverseCurve: Curves.bounceIn,
  );

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 값을 가지고 있는 역할
  // 그리고 값이 변경되면 build 메서드를 호출하지 않고 알림
  final ValueNotifier<double> _range = ValueNotifier(0.0);

  void _onChange(double value) {
    _range.value = value; // ✅ 슬라이더 값 업데이트
    _animationController.value = value; // ✅ 애니메이션 위치도 이동
    //_animationController.animateTo(value); // 그 지점까지 애니메이션을 해줌
  }

  bool _looping = false;

  void _toggleLooping() {
    if (_looping) {
      _animationController.stop();
    } else {
      _animationController.repeat(reverse: true);
    }
    setState(() {
      _looping = !_looping;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Explicit Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            SlideTransition(
              position: _position,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: SizedBox(height: 300, width: 300),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _play, child: Text('Play')),
                ElevatedButton(onPressed: _pause, child: Text('Pause')),
                ElevatedButton(onPressed: _rewind, child: Text('Reverse')),
                ElevatedButton(
                  onPressed: _toggleLooping,
                  child: _looping ? Text('stop Loop') : Text('Loop'),
                ),
              ],
            ),
            SizedBox(height: 25),
            // 오직 여기서만 rebuild
            ValueListenableBuilder(
              valueListenable: _range,
              builder: (context, value, child) {
                return Slider(value: value, onChanged: _onChange);
              },
            ),
          ],
        ),
      ),
    );
  }
}
