import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/constants.dart';
import 'package:weather/ui/detail_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants = Constants();

  // State variables for weather data
  int temperature = 0;
  String weatherStateName = 'Loading...';
  int humidity = 0;
  int windSpeed = 0;
  String currentDate = 'Loading...';
  String imageUrl = '';
  String location = 'Delhi'; // Default city
  int woeid = 28743736; // WOEID for Delhi

  // Lists to hold cities and weather data
  List<City> selectedCities = City.getSelectedCities();
  List<String> cities = [];

  // API URLs
  String searchLocationUrl = 'https://www.metaweather.com/api/location/search/?query=';
  String searchWeatherUrl = 'https://www.metaweather.com/api/location/';

  @override
  void initState() {
    super.initState();
    populateDropdown();
    fetchWeather(location);
  }

  void populateDropdown() {
    cities = selectedCities.where((city) => city.city != location).map((city) => city.city).toList();
  }

  void fetchWeather(String location) async {
    try {
      // Step 1: Search for location (city)
      var locationResponse = await http.get(Uri.parse(searchLocationUrl + location));
      if (locationResponse.statusCode == 200) {
        var locationResult = json.decode(locationResponse.body);
        if (locationResult != null && locationResult.isNotEmpty) {
          var woeid = locationResult[0]['woeid']; // Get woeid for the first location
          // Step 2: Fetch weather using woeid
          var weatherResponse = await http.get(Uri.parse(searchWeatherUrl + woeid.toString()));
          if (weatherResponse.statusCode == 200) {
            var weatherResult = json.decode(weatherResponse.body);
            var weather = weatherResult['consolidated_weather'];

            setState(() {
              temperature = weather[0]['the_temp'].round();
              weatherStateName = weather[0]['weather_state_name'];
              humidity = weather[0]['humidity'].round();
              windSpeed = (weather[0]['wind_speed'] * 1.60934).round(); // Convert to km/h
              imageUrl = weatherStateName.replaceAll(' ', '').toLowerCase();
              currentDate = DateFormat('EEEE, MMM d').format(DateTime.parse(weather[0]['applicable_date']));
            });
          } else {
            print('Failed to load weather data. Status code: ${weatherResponse.statusCode}');
          }
        } else {
          print('Location not found');
        }
      } else {
        print('Failed to load location data. Status code: ${locationResponse.statusCode}');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myConstants.primaryColor,
        title: DropdownButton<String>(
          value: location,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          dropdownColor: myConstants.primaryColor,
          onChanged: (String? newValue) {
            setState(() {
              location = newValue!;
              fetchWeather(location);
            });
          },
          items: [
            DropdownMenuItem<String>(
              value: location,
              child: Text(
                location,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ...cities.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                currentDate,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: size.width,
                height: 250,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [myConstants.primaryColor, myConstants.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weatherStateName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (imageUrl.isNotEmpty)
                          Image.asset(
                            'assets/$imageUrl.png',
                            width: 100,
                            height: 100,
                          ),
                        Text(
                          '$temperature°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  weatherInfoCard('Humidity', '$humidity%', 'assets/humidity.png'),
                  weatherInfoCard('Wind Speed', '$windSpeed km/h', 'assets/windspeed.png'),
                  weatherInfoCard('Max Temp', '$temperature°C', 'assets/max-temp.png'),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '7-Day Forecast',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7, // You can adjust this based on your API response or requirement
                  itemBuilder: (context, index) {
                    var date = DateFormat('E').format(DateTime.now().add(Duration(days: index)));
                    var dayTemp = temperature.toString();
                    var dayWeather = weatherStateName.replaceAll(' ', '').toLowerCase();
                    return weatherDayCard(date, dayTemp, dayWeather);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget weatherInfoCard(String label, String value, String assetPath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, width: 50, height: 50),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget weatherDayCard(String date, String temp, String assetPath) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Image.asset('assets/$assetPath.png', width: 40),
          Text(
            '$temp°C',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

