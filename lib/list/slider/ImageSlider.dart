import 'dart:async';

import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;

  ImageSlider({required this.images});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;
  Timer? _timer;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      final int newIndex = (_currentIndex + 1) % widget.images.length;
      setState(() {
        _currentIndex = newIndex;
        _pageController.animateToPage(newIndex,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < widget.images.length; i++) {
      indicators.add(
        i == _currentIndex
            ? Icon(
                Icons.fiber_manual_record,
                size: 12.0,
                color: Colors.blue,
              )
            : Icon(
                Icons.fiber_manual_record,
                size: 12.0,
                color: Colors.grey,
              ),
      );
    }
    return indicators;
  }

  Widget build(BuildContext context) {

    // Set height to 200.0 for mobile devices
    double height = 200.0;

    double screenWidth = MediaQuery.of(context).size.height;
    if (screenWidth > 576) {
      height = 150;
    }
    if (screenWidth > 768) {
      height = 200;
    }
    if (screenWidth > 992) {
      height = 250;
    }
    if (screenWidth > 1200) {
      height = 350;
    }

    EdgeInsetsGeometry paddingValue = EdgeInsets.all(10.0);
    if (screenWidth > 1200) {
      paddingValue = EdgeInsets.fromLTRB(240.0, 20.0, 240.0, 40.0);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: widget.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return FittedBox(
                    fit: BoxFit.cover,
                    child: Image.network(widget.images[index]),
                  );
                },
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                controller: _pageController,
              ),
              Positioned(
                bottom: 10.0,
                left: 0.0,
                right: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
