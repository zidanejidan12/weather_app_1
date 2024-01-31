import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String _latitude = '';
  String _longitude = '';
  String _city = '';
  String _weather = '';
  String _iconUrl = '';

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
    });
    getWeatherData();
  }

  void getWeatherData() async {
    String apiKey = 'c36d00a1ade6f97e5f7d9861c3dff92c';
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$_latitude&lon=$_longitude&appid=$apiKey';

    http.Response response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        _city = data['name'];
        _weather = data['weather'][0]['main'];
        _iconUrl =
            'http://openweathermap.org/img/w/${data['weather'][0]['icon']}.png';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String googleApiKey = 'AIzaSyAVsku3_R5bbF-Vc9dt7fnZgu_iR1BYLUM';
    String mapUrl =
        'https://maps.googleapis.com/maps/api/staticmap?center=$_latitude,$_longitude&zoom=14&size=400x400&key=$googleApiKey';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Latitude: $_latitude',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Longitude: $_longitude',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  'City: $_city',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Weather: $_weather',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Image.network(
                  _iconUrl,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                Image.network(
                  mapUrl,
                  width: 400,
                  height: 300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
