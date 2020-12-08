import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

const apiKey = 'b480375788a0883deaccdae75a9438b1';
const url = 'https://api.openweathermap.org/data/2.5/weather';
const units = 'units=imperial';

class WeatherModel {

  Future<dynamic> getCityWeather(String cityName) async {
    var url2 = '$url?q=$cityName&apiKey=$apiKey&$units';
    NetworkHelper networkHelper = NetworkHelper(url2);

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    String myUrl = '$url?lat=${location.latitude}&lon=${location.longitude}&$units&appid=$apiKey';
    // print(myUrl);
    NetworkHelper networkHelper = NetworkHelper(myUrl);

    var weatherData = await networkHelper.getData();

    return weatherData;
  }

  IconData getWeatherIcon(int condition) {
    String nightDay;

    // Hack alert
    // Using local time to determine day or night icons rather than actual city time
    // TODO: Response includes a timezone value, use that to determine actual city time
    var now = new DateTime.now();

    if (now.hour > 6 && now.hour < 18) {
      nightDay = 'day';
    } else {
      nightDay = 'night';
    }

    if (condition < 300) {
      // Thunderstorms
      if (nightDay == 'day') {
        return WeatherIcons.day_thunderstorm;
      } else {
        return WeatherIcons.night_thunderstorm;
      }
    } else if (condition < 400) {
      // Drizzle
      if (nightDay == 'day') {
        return WeatherIcons.day_sprinkle;
      } else {
        return WeatherIcons.night_sprinkle;
      }
    } else if (condition < 600) {
      // Rain
      if (nightDay == 'day') {
        return WeatherIcons.day_rain;
      } else {
        return WeatherIcons.night_rain;
      }
    } else if (condition < 700) {
      // Snow
      if (nightDay == 'day') {
        return WeatherIcons.day_snow;
      } else {
        return WeatherIcons.night_snow;
      }
    } else if (condition < 800) {
      // Mist, Fog
      if (nightDay == 'day') {
        return WeatherIcons.day_fog;
      } else {
        return WeatherIcons.night_fog;
      }
    } else if (condition == 800) {
      // Sunny
      if (nightDay == 'day') {
        return WeatherIcons.day_sunny;
      } else {
        return WeatherIcons.night_clear;
      }
    } else if (condition <= 804) {
      // Cloudy
      if (nightDay == 'day') {
        return WeatherIcons.day_cloudy;
      } else {
        return WeatherIcons.night_cloudy;
      }
    } else {
      return WeatherIcons.alien;
    }
  }

  String getMessage(int temp) {
    if (temp > 95) {
      return 'It\'s 🍦 time';
    } else if (temp > 80) {
      return 'Time for shorts and 👕';
    } else if (temp < 60) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
