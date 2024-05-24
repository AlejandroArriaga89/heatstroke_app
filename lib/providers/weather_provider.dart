import 'dart:async';
import 'package:heatstroke_app/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherProvider extends ChangeNotifier {
  final String _baseUrl = 'api.openweathermap.org';
  // final String _city = 'Celaya, Guanajuato, Mx';
  final String _lat = '20.5167';
  final String _lon = '-100.8167';
  final String _apiKey = '3d16098103ec59a3bde073774be3967e';
  Clima actualClima = Clima(
    temp: 0.0,
    feelsLike: 0.0,
    tempMin: 0.0,
    tempMax: 0.0,
    pressure: 0,
    humidity: 0,
    seaLevel: 0,
    grndLevel: 0,
  );
  Uvi uviActual = Uvi(
    lat: 0.0,
    lon: 0.0,
    dateIso: DateTime.now(),
    date: 0,
    value: 0.0,
  );

  WeatherProvider() {
    getClimaActual();
    getUviActual();
  }

  Future<String> getJsonData(String endpoint) async {
    final url = Uri.https(_baseUrl, endpoint, {
      // 'q': _city,
      'lat': _lat,
      'lon': _lon,
      'units': 'metric',
      'appid': _apiKey,
    });
    var response = await http.get(url);
    print(response.body);
    return response.body;
  }

  getUviActual() async {
    // Await the http get response, then decode the json-formatted response.
    // final Map<String, dynamic> decodedData = json.decode(response.body);
    // if (response.statusCode != 200) return print('error');
    final jsonData = await getJsonData('/data/2.5/uvi');
    final uvi = Uvi.fromJson(jsonData);
    uviActual = uvi;
    notifyListeners();
  }

  Future getClimaActual() async {
    // Await the http get response, then decode the json-formatted response.
    // final Map<String, dynamic> decodedData = json.decode(response.body);
    // if (response.statusCode != 200) return print('error');
    final jsonData = await getJsonData('/data/2.5/weather');
    final clima = Clima.fromJson(jsonData);
    actualClima = clima;
    notifyListeners();
  }
}
