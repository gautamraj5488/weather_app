import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/models/constants.dart';
import 'package:weather/ui/welcome.dart';
import 'package:weather/widgets/weather_item.dart';

class WeatherDetailPage extends StatefulWidget {
  final List weatherData;
  final int initialIndex;
  final String city;

  const WeatherDetailPage({
    Key? key,
    required this.weatherData,
    required this.initialIndex,
    required this.city,
  }) : super(key: key);

  @override
  _WeatherDetailPageState createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  late String currentImageUrl;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Constants constants = Constants();

    final Shader gradientShader = LinearGradient(
      colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    int selectedWeatherIndex = widget.initialIndex;
    var currentWeatherState = widget.weatherData[selectedWeatherIndex]['weather_state_name'];
    currentImageUrl = currentWeatherState.replaceAll(' ', '').toLowerCase();

    return Scaffold(
      backgroundColor: constants.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: constants.secondaryColor,
        elevation: 0.0,
        title: Text(widget.city),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Welcome()),
              );
            },
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 150,
              width: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.weatherData.length,
                itemBuilder: (context, index) {
                  var futureWeatherState = widget.weatherData[index]['weather_state_name'];
                  var futureWeatherImage = futureWeatherState.replaceAll(' ', '').toLowerCase();
                  var parsedDate = DateTime.parse(widget.weatherData[index]['applicable_date']);
                  var formattedDay = DateFormat('EEEE').format(parsedDate).substring(0, 3);

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.only(right: 20),
                    width: 80,
                    decoration: BoxDecoration(
                      color: index == selectedWeatherIndex ? Colors.white : const Color(0xff9ebcf9),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 5,
                          color: Colors.blue.withOpacity(.3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.weatherData[index]['the_temp'].round()}°C',
                          style: TextStyle(
                            fontSize: 17,
                            color: index == selectedWeatherIndex ? Colors.blue : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset(
                          'assets/$futureWeatherImage.png',
                          width: 40,
                        ),
                        Text(
                          formattedDay,
                          style: TextStyle(
                            fontSize: 17,
                            color: index == selectedWeatherIndex ? Colors.blue : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: screenSize.height * .55,
              width: screenSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    right: 20,
                    left: 20,
                    child: Container(
                      width: screenSize.width * .7,
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.center,
                          colors: [Color(0xffa9c1f5), Color(0xff6696f5)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(.1),
                            offset: Offset(0, 25),
                            blurRadius: 3,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -40,
                            left: 20,
                            child: Image.asset(
                              'assets/$currentImageUrl.png',
                              width: 150,
                            ),
                          ),
                          Positioned(
                            top: 120,
                            left: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                currentWeatherState,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: screenSize.width * .8,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WeatherItem(
                                    text: 'Wind Speed',
                                    value: widget.weatherData[selectedWeatherIndex]['wind_speed'].round(),
                                    unit: 'km/h',
                                    imageUrl: 'assets/windspeed.png',
                                  ),
                                  WeatherItem(
                                    text: 'Humidity',
                                    value: widget.weatherData[selectedWeatherIndex]['humidity'].round(),
                                    unit: '',
                                    imageUrl: 'assets/humidity.png',
                                  ),
                                  WeatherItem(
                                    text: 'Max Temp',
                                    value: widget.weatherData[selectedWeatherIndex]['max_temp'].round(),
                                    unit: '°C',
                                    imageUrl: 'assets/max-temp.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.weatherData[selectedWeatherIndex]['the_temp'].round().toString(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader = gradientShader,
                                  ),
                                ),
                                Text(
                                  '°',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader = gradientShader,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 300,
                    left: 20,
                    child: SizedBox(
                      height: 200,
                      width: screenSize.width * .9,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.weatherData.length,
                        itemBuilder: (context, index) {
                          var futureWeatherName = widget.weatherData[index]['weather_state_name'];
                          var futureImageUrl = futureWeatherName.replaceAll(' ', '').toLowerCase();
                          var weatherDate = DateTime.parse(widget.weatherData[index]['applicable_date']);
                          var formattedDate = DateFormat('d MMMM, EEEE').format(weatherDate);

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            height: 80,
                            width: screenSize.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: constants.secondaryColor.withOpacity(.1),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(color: Color(0xff6696f5)),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.weatherData[index]['max_temp'].round()}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        '/',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                        ),
                                      ),
                                      Text(
                                        '${widget.weatherData[index]['min_temp'].round()}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/$futureImageUrl.png',
                                        width: 30,
                                      ),
                                      Text(futureWeatherName),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
