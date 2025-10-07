import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

final List<Map<String, String>> movies = [
  {
    "title": "보스",
    "title_en": "NO OTHER CHOICE",
    "star": "⭐⭐⭐⭐▫️(4/5)",
    "subdescription": "갑작스러운 보스의 죽음! 차기 보스는 누구?",
    "description":
        "보스 후보1. 차기 보스 0순위지만, 조직이 아닌 중식당 미미루로 전국구 평정을 꿈꾸는 순태(조우진) \n보스 후보2. 조직 내 입지는 충분하나 운명처럼 만난 탱고에 인생을 건, 차기 보스 유력자 ‘강표’(정경호)\n보스 후보3. 유일하게 보스를 갈망하지만, 그 누구도 보스감이라 생각하지 않는, 보스 부적격자 ‘판호’(박지환)\n그리고\n미미루 배달원으로 잠입한 언더커버 경찰 ‘태규’(이규형)까지 가세하며\n치열한 보스 ‘양보’ 전은 예측불허 대혼란으로 치닫는데..\n세력 전쟁보다 살벌한 보스 대결 양보 전쟁!\n올 추석, 웃기는 놈이 보스다!",
  },
  {
    "title": "어쩔수가없다",
    "star": "⭐⭐⭐▫️▫️(3/5)",
    "title_en": "NO OTHER CHOICE",
    "subdescription": "‘다 이루었다’는 생각이 들 만큼 삶에 만족하던 25년 경력의 제지 전문가 ‘만수’(이병헌).",
    "description":
        "아내 ‘미리’(손예진), 두 아이, 반려견들과 함께 행복한 일상을 보내던 만수는\n회사로부터 돌연 해고 통보를 받는다.\n\n“미안합니다. 어쩔 수가 없습니다.”\n\n목이 잘려 나가는 듯한 충격에 괴로워하던 만수는,\n가족을 위해 석 달 안에 반드시 재취업하겠다고 다짐한다.\n그 다짐이 무색하게도, 그는 1년 넘게 마트에서 일하며 면접장을 전전하고,\n급기야 어렵게 장만한 집마저 빼앗길 위기에 처한다.\n\n무작정 [문 제지]를 찾아가 필사적으로 이력서를 내밀지만,\n‘선출’(박희순) 반장 앞에서 굴욕만 당한다.\n[문 제지]의 자리는 누구보다 자신이 제격이라고 확신한 만수는 모종의 결심을 한다.\n\n“나를 위한 자리가 없다면, 내가 만들어서라도 취업에 성공하겠다.”",
  },
  {
    "title": "극장판 체인소 맨: 레제편",
    "star": "⭐⭐⭐⭐⭐(5/5)",
    "title_en": "NO OTHER CHOICE",
    "subdescription": "인기 애니메이션 '체인소 맨' 첫 극장판 국내 상륙!",
    "description":
        "압도적 배틀 액션이 스크린에서 폭발한다!\n\n데블 헌터로 일하는 소년 ‘덴지’는 조직의 배신으로 죽음에 내몰린 순간\n전기톱 악마견 ‘포치타’와의 계약으로 하나로 합쳐져\n누구도 막을 수 없는 존재 ‘체인소 맨’으로 다시 태어난다.\n\n악마와 사냥꾼, 그리고 정체불명의 적들이 얽힌 잔혹한 전쟁 속에서\n‘레제’라는 이름의 미스터리한 소녀가 ‘덴지’ 앞에 나타나는데…\n‘덴지’는 사랑이라는 감정에 이끌려 지금껏 가장 위험한 배틀에 몸을 던진다!",
  },
];

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);

  int _currentPage = 0;
  ValueNotifier<double> _scroll = ValueNotifier(0.0);

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  bool _showDetail = false; // 👈 디테일 화면 표시 여부
  void _onVerticalDrag(DragUpdateDetails details) {
    if (details.delta.dy > 8) {
      // 아래로 드래그 → detail 열기
      setState(() => _showDetail = true);
    } else if (details.delta.dy < -8) {
      // 위로 드래그 → detail 닫기
      setState(() => _showDetail = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page == null) return;
      _scroll.value = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: _onVerticalDrag,
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Container(
                key: ValueKey(_currentPage),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/${_currentPage + 1}.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    color: _showDetail
                        ? Colors.black.withOpacity(0.8)
                        : Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),

            AnimatedSlide(
              offset: _showDetail ? const Offset(0, 0.75) : Offset.zero,
              duration: 350.ms,
              child: PageView.builder(
                onPageChanged: _onPageChanged,
                controller: _pageController,
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _scroll,
                        builder: (context, scroll, child) {
                          final difference = (scroll - index).abs();
                          final scale = 1 - (difference * 0.1);
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              height: 550,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: MovieCard(index: index),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            if (_showDetail)
              Align(
                alignment: Alignment.topCenter,
                child: MovieDetailScreen(
                  index: _currentPage,
                ).animate().slideY(begin: -1, end: -0.2),
              ),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatefulWidget {
  final int index;
  const MovieCard({super.key, required this.index});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    final movie = movies[widget.index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Column(
        children: [
          Container(
            height: 365,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                image: AssetImage("assets/${widget.index + 1}.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            movie["title"]!,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(movie['star']!, style: TextStyle(fontSize: 15)),
          SizedBox(height: 10),
          Text(movie["subdescription"]!),
        ],
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final int index;
  const MovieDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final movie = movies[index];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              SizedBox(height: 200),
              Text(
                movie['title_en']!,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                movie['title']!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              Text(
                movie['star']!,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              Text(
                movie['subdescription']!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                movie['description']!,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
