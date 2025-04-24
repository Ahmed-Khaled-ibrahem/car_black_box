import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherCard extends StatefulWidget {
  final double lat;
  final double lon;

  const WeatherCard({super.key, required this.lat, required this.lon});

  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  String locationName = "Loading...";
  double temperature = 0.0;
  int weatherCode = 0;
  double windSpeed = 0.0;
  int humidity = 0;

  @override
  void initState() {
    super.initState();
    fetchLocation();
    fetchWeather();
  }

  /// Fetch place name using Nominatim (OpenStreetMap)
  Future<void> fetchLocation() async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=${widget.lat}&lon=${widget.lon}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        locationName = data["address"]["city"] ?? data["address"]["town"] ?? "Dahaban";
      });
    }
  }

  /// Fetch weather data from Open-Meteo
  Future<void> fetchWeather() async {
    final url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=${widget.lat}&longitude=${widget.lon}&current=temperature_2m,weathercode,wind_speed_10m,relative_humidity_2m");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        temperature = data["current"]["temperature_2m"];
        weatherCode = data["current"]["weathercode"];
        windSpeed = data["current"]["wind_speed_10m"];
        humidity = data["current"]["relative_humidity_2m"];
      });
    }
  }

  String getWeatherDescription(int code) {
    if (code == 0) return "Clear Sky ☀️";
    if (code == 1 || code == 2) return "Partly Cloudy 🌤️";
    if (code == 3) return "Cloudy ☁️";
    if (code >= 51 && code <= 67) return "Rain 🌧️";
    if (code >= 71 && code <= 77) return "Snow ❄️";
    if (code >= 95) return "Thunderstorm ⛈️";
    return "Unknown Weather ❓";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // gradient:  LinearGradient(
          //   colors: [ const Color(0xFF7c55d4),  const Color(0xFF7c55d4).withGreen(130)], // Gradient colors
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          color: Colors.red.withOpacity(0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getWeatherDescription(weatherCode),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "${temperature.toStringAsFixed(1)}°C",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    locationName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Column(
              //       children: [
              //         const Icon(Icons.air, size: 30),
              //         Text("${windSpeed.toStringAsFixed(1)} km/h"),
              //       ],
              //     ),
              //     Column(
              //       children: [
              //         const Icon(Icons.water_drop, size: 30),
              //         Text("$humidity% Humidity"),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
