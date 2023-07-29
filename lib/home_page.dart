import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weatherapp/additional_information.dart';
import 'package:weatherapp/secrets.dart';
import 'package:weatherapp/weather_forecast.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Future<Map<String, dynamic>> getWeatherApi() async {
    String country = "uk";
    String city = "London";
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city,$country&APPID=$appID'));
      final data = (jsonDecode(response.body));
      if (response.statusCode != 200) {
        throw "An Error occured";
      }
      return data;
    } catch (e) {
      (throw e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print("refresh");
              setState(() {

              });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
          future: getWeatherApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              final data = snapshot.data!;
              final mainTemp = data['list'][0]['main']['temp'];

              final currentsky = data['list'][0]['weather'][0]['main'];
              //WEATHER FORECAST

              //ADDITIONAL INFORMATION
              final humidityValue = data['list'][0]['main']['humidity'];
              final pressureValue = data['list'][0]['main']['pressure'];
              final windSpeed = data['list'][0]['wind']['speed'];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //banner display
                    SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "$mainTemp K",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                      letterSpacing: 1,
                                      wordSpacing: 2),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Icon(
                                  currentsky == 'Clouds' || currentsky == 'Rain'
                                      ? Icons.sunny
                                      : Icons.cloud,
                                  color: Colors.white,
                                  size: 60,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "$currentsky",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Weather Forecast",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 133,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 39,
                          itemBuilder: (context, index) {
                            final time = DateTime.parse(
                                data['list'][index + 1]['dt_txt'].toString());
                            return WeatherForecast(
                                iconName: data['list'][index + 1]['weather'][0]
                                                ['main'] ==
                                            'Rain' ||
                                        data['list'][index + 1]['weather'][0]
                                                ['main'] ==
                                            'clouds'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                temperature: data['list'][index + 1]['main']
                                        ['temp']
                                    .toString(),
                                time: DateFormat.j().format(time));
                          }),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Additional Information",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 9,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AdditionalInformation(
                            value: '$humidityValue',
                            condition: 'Humidity',
                            icon: Icons.water_drop),
                        AdditionalInformation(
                            value: '$windSpeed',
                            condition: 'Wind Speed',
                            icon: Icons.air),
                        AdditionalInformation(
                            value: '$pressureValue',
                            condition: 'Pressure',
                            icon: Icons.beach_access)
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
