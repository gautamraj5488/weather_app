import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants = Constants();

  // State variables for weather data
  int temperature = 0;
  String weatherDescription = 'Loading...';
  int humidity = 0;
  double windSpeed = 0;
  String currentDate = 'Loading...';
  String iconCode = '';
  String location = 'Delhi'; // Default location
  String apiKey = '194c3c4447f31cf05698b9167d2831a2';
  String apiUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // Lists to hold cities and weather data
  List<City> selectedCities = City.getSelectedCities();
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    populateDropdown();
    fetchWeather(location); // Fetch weather data for default location on startup
  }

  void populateDropdown() {
    cities = selectedCities.map((city) => city.city).toList(); // Populate city names in dropdown
  }

  Future<void> fetchWeather(String location) async {
    try {
      // Construct the API URL with query parameters
      var url = Uri.parse('$apiUrl?q=$location&appid=$apiKey&units=metric');

      // Make the API call
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var weatherData = jsonDecode(response.body);

        setState(() {
          temperature = weatherData['main']['temp'].round();
          weatherDescription = weatherData['weather'][0]['description'];
          humidity = weatherData['main']['humidity'];
          windSpeed = weatherData['wind']['speed'];
          iconCode = weatherData['weather'][0]['icon'];
          currentDate = DateFormat('EEEE, MMM d').format(DateTime.now());
        });
      } else {
        print('Failed to load weather data. Status code: ${response.statusCode}');
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
            if (newValue != null) {
              setState(() {
                location = newValue; // Update selected location
                fetchWeather(location); // Fetch weather data for the selected location
              });
            }
          },
          items: cities.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          }).toList(),
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
                      weatherDescription,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (iconCode.isNotEmpty)
                          Image.network(
                            'https://openweathermap.org/img/wn/$iconCode.png',
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
                    var dayWeather = weatherDescription.toLowerCase();
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
