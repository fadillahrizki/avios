import 'package:avios/screens/onboarding/list_board.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingSreen extends StatefulWidget {
  const OnBoardingSreen({super.key});

  @override
  State<OnBoardingSreen> createState() => _OnBoardingSreenState();
}

class _OnBoardingSreenState extends State<OnBoardingSreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  handleOnBoarding() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('onBoarding', true);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.6,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: false,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: listBoard.map((data) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(data['img']),
                            Text(
                              textAlign: TextAlign.center,
                              '${data['title']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              '${data['subtitle']}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ));
                  },
                );
              }).toList(),
            ),
          ),
          const Spacer(),
          Card(
            elevation: 30,
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: ListTile(
                leading: _currentIndex != listBoard.length - 1
                    ? TextButton(
                        onPressed: () {
                          _carouselController.previousPage();
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : const Text(''),
                title: _currentIndex != listBoard.length - 1
                    ? DotsIndicator(
                        dotsCount: listBoard.length,
                        position: _currentIndex,
                        decorator: const DotsDecorator(
                          size: Size(10, 10),
                          activeSize: Size(12, 12),
                          activeColor: Color(0xFF77B6C9),
                          color: Colors.grey,
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          handleOnBoarding();
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                trailing: _currentIndex != listBoard.length - 1
                    ? TextButton(
                        onPressed: () {
                          _carouselController.nextPage();
                        },
                        child: const Text(
                          'Next',
                        ),
                      )
                    : const Text(''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
