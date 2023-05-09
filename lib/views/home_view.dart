import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/constants/api_keys/api_keys.dart';
import 'package:weather_app/data/weather_data.dart';
import 'package:weather_app/views/search_views.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String cityName = '';
  String country = '';
  dynamic temperature;
  String icons = '';
  bool isLoading = false;
  String description = '';

  @override
  void initState() {
    showWeatherByLocation();
    super.initState();
  }

  Future<void> showWeatherByLocation() async {
    final position = await _getPosition();

    log('latitude==>${position.latitude}');
    log('longitude==>${position.longitude}');
    await getWeather(position);
  }

  Future<void> getWeather(Position position) async {
    setState(() {
      isLoading = true;
    });
    try {
      final client = http.Client();
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${ApiKeys.myApiKey}';
      Uri uri = Uri.parse(url);
      final joop = await client.get(uri);
      final jsonJoop = jsonDecode(joop.body);
      cityName = jsonJoop['name'];
      country = jsonJoop['sys']['country'];
      final double kelvin = jsonJoop['main']['temp'];

      temperature = weatherData.calculateWeather(kelvin);
      description = weatherData.getDescription(num.parse(temperature))!;
      icons = weatherData.getWeatherIcon(double.parse(temperature))!;

      log('cityName==>${jsonJoop['name']}');
      setState(() {
        isLoading = false;
      });
      log('response==>${joop.body}');
      log('response json==> ${jsonJoop}');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getSearchedCityName(String typeCityName) async {
    final client = http.Client();
    try {
      Uri uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$typeCityName&appid=${ApiKeys.myApiKey}');
      final response = await client.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log('data==>${data}');
        cityName = data['name'];
        country = data['sys']['country'];
        final double kelvin = data['main']['temp'];

        temperature = weatherData.calculateWeather(kelvin);
        description = weatherData.getDescription(num.parse(temperature))!;
        icons = weatherData.getWeatherIcon(num.parse(temperature))!;
        setState(() {});
      }
    } catch (e) {}
  }

  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: isLoading == true
              ? CircularProgressIndicator(
                  color: Colors.black,
                )
              : InkWell(
                  onTap: () async {
                    await showWeatherByLocation();
                  },
                  child: Icon(
                    Icons.near_me,
                    size: 50,
                  ),
                ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchView(),
                  ),
                );
              },
              child: Icon(
                Icons.location_city,
                size: 50,
              ),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    backgroundColor: Colors.green,
                  ),
                )
              : Stack(
                  children: [
                    Positioned(
                      top: 130,
                      left: 40,
                      child: Text(
                        '$temperature\u2103',
                        style: TextStyle(fontSize: 80, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 40,
                      child: Text(
                        'Country:$country',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 160,
                      child: Text(
                        icons,
                        style: TextStyle(fontSize: 80, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 300,
                      left: 50,
                      right: 50,
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 400,
                      left: 50,
                      right: 20,
                      child: Text(
                        '🧣',
                        style: TextStyle(fontSize: 70, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 400,
                      left: 150,
                      child: Text(
                        '🧤',
                        style: TextStyle(fontSize: 70, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 600,
                      left: 50,
                      right: 50,
                      child: Text(
                        cityName,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
