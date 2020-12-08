import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_icons/weather_icons.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature = 0;
  IconData weatherIcon;
  String cityName;
  String weatherMessage;
  String description;
  int humidity;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }

      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      description = weatherData['weather'][0]['main'];
      humidity = weatherData['main']['humidity'];
      weatherIcon = weather.getWeatherIcon(condition);
      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      // TODO: Add forecast screen
                    },
                    child: Icon(
                      Icons.wb_sunny,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      if (typedName != null) {
                        var weatherData = await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$temperature°',
                    textAlign: TextAlign.center,
                    style: kTempTextStyle,
                  ),
                  SizedBox(width: 20.0),
                  BoxedIcon(
                    weatherIcon,
                    size: 70.0,
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Text(
                '$cityName',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
              SizedBox(height: 30.0),
              Text(
                '$description',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 30),
              ),
              SizedBox(height: 10.0),
              Text(
                'Humidity $humidity%',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}