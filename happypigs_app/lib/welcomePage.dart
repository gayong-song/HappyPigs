import 'package:flutter/material.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';


class WelcomePage extends StatelessWidget {
  final pageList = [
    PageModel(
        color: const Color(0xFF678FB4),
        heroImagePath: 'assets/gif/giphy.gif',
        title: Text('Hello',
            style: TextStyle(
              fontFamily: 'Oi',
              // fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text('Welcome to\nHappy Piggy World',
            textAlign: TextAlign.center,
            style: TextStyle(
              // fontFamily: 'Oi',
              color: Colors.white,
              fontWeight: FontWeight.w100,
              fontSize: 24.0,
            )),
        icon: Icon(Icons.star),
        // iconImagePath: 'assets/png/key.png'
    ),
    PageModel(
        color: const Color(0xFF65B0B4),
        heroImagePath: 'assets/gif/colorfulpig.gif',
        title: Text('Diary',
            style: TextStyle(
              fontFamily: 'Oi',
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text('Diary for Eating',
            textAlign: TextAlign.center,
            style: TextStyle(
              // fontFamily: 'Oi',
              color: Colors.white,
              fontWeight: FontWeight.w100,
              fontSize: 24.0,
            )),
        icon: Icon(Icons.camera)
        // iconImagePath: 'assets/png/wallet.png'
    ),
    PageModel(
      color: const Color(0xFF9B90BC),
      heroImagePath: 'assets/gif/purple_pig.gif',
      title: Text('Enjoy',
          style: TextStyle(
            fontFamily: 'Oi',
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Text('Let\'s Start!',
          textAlign: TextAlign.center,
          style: TextStyle(
            // fontFamily: 'Oi',
            color: Colors.white,
            fontWeight: FontWeight.w100,
            fontSize: 24.0,
          )),
      icon: Icon(Icons.fastfood)
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: () =>
            Navigator.of(context).pushReplacementNamed('/mainPage'),
        onSkipButtonPressed: () =>
            Navigator.of(context).pushReplacementNamed('/mainPage'),
      ),
    );
  }
}
