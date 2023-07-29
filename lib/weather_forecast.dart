import 'package:flutter/material.dart';

class WeatherForecast extends StatelessWidget {
  final String time;
  final IconData iconName;
  final String temperature;
  const WeatherForecast(
      {super.key,
      required this.iconName,
      required this.temperature,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 133,
      width: 100,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        borderOnForeground: true,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,maxLines: 1,overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),
              ),
              SizedBox(
                height: 5,
              ),
              Icon(
                iconName,
                size: 40,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                temperature,
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}
