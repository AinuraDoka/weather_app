import 'dart:developer';

import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: _controller,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Керектуу шаарды жаз',
                  hintStyle:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: Colors.lightGreenAccent),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.purple),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                ),
                backgroundColor:
                    MaterialStateProperty.all(Color.fromARGB(255, 81, 81, 214)),
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.pop(context, _controller.text);
                  log('${_controller.text}');
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: Text(
                'Издоо',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
