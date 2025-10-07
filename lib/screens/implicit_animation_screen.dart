import 'package:flutter/material.dart';

class ImplicitAnimationScreen extends StatefulWidget {
  const ImplicitAnimationScreen({super.key});

  @override
  State<ImplicitAnimationScreen> createState() =>
      _ImplicitAnimationScreenState();
}

class _ImplicitAnimationScreenState extends State<ImplicitAnimationScreen> {
  bool visible = true;

  void _trigger() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Implict Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<Color?>(
              tween: ColorTween(begin: Colors.red, end: Colors.green),
              duration: const Duration(seconds: 5),
              curve: Curves.bounceInOut,
              // child에 이미지 넣고 builder에서는 색 필터만 바꿔 rebuild 비용 줄이기
              child: Image.network(
                "https://lh4.googleusercontent.com/on7Yj1rShJRRBy88rTmptLVzMI4gEBDBabmSMv-GGsPIo5umfS5dpSJp3b4EoqKtnxdOYXeHSyct6m2fLYKckaikrUJn91PNWkIYXtkrCljcvdEnGdf_nQM5Qw6bQY4q6jvbWiBcC3WPTIcDS_lizv3R25oVAF_H0PNzvRo7JivPSiZR",
                errorBuilder: (context, error, stack) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
              builder: (context, color, child) {
                // color는 nullable이므로 널 안전 처리
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    color ?? Colors.transparent,
                    BlendMode.modulate,
                  ),
                  child: child,
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _trigger, child: Text('Go')),
          ],
        ),
      ),
    );
  }
}
