import 'package:flutter/material.dart';

class TestFuture extends StatefulWidget {
  const TestFuture({Key? key}) : super(key: key);

  @override
  _TestFutureState createState() => _TestFutureState();
}

class _TestFutureState extends State<TestFuture> {
  String text = 'Sinhronno ishtedi';
  String? textAsync;

  void initState() {
    getText();
    super.initState();
  }

  Future<String> getText() async {
    try {
      return await Future.delayed(Duration(seconds: 6), () {
        setState(() {});
        return textAsync = 'Text Async keldi';
      });
    } catch (problem) {
      throw Exception(problem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 35,
            ),
          ),
          Text(
            textAsync ?? 'Emi kelet',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
          Text(
            ('Salam'),
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ],
      ),
    );
  }
}
