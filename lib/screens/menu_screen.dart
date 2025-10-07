import 'package:flutter/material.dart';
import 'package:master_class/screens/apple_watch_screen.dart';
import 'package:master_class/screens/explicit_animation_screen.dart';
import 'package:master_class/screens/implicit_animation_screen.dart';
import 'package:master_class/screens/movie_screen.dart';
import 'package:master_class/screens/swiping_card_challenge.dart';
import 'package:master_class/screens/swiping_cards_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Animations")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const ImplicitAnimationScreen());
              },
              child: Text('Implicit Animations'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const ExplicitAnimationScreen());
              },
              child: Text('Explicit Animations'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const AppleWatchScreen());
              },
              child: Text('Apple Watch Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const SwipingCardsScreen());
              },
              child: Text('Swiping Cards'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const SwipingCardChallenge());
              },
              child: Text('Swiping Cards Challenge'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const MovieScreen());
              },
              child: Text('MovieScreen'),
            ),
          ],
        ),
      ),
    );
  }
}
