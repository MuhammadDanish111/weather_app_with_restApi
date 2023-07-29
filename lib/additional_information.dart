import 'package:flutter/material.dart';
class AdditionalInformation extends StatelessWidget {
  final String condition;
  final IconData icon;
  final String value;
  const AdditionalInformation({super.key,required this.value,required this.condition,required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [Icon(icon,size: 35,),

            SizedBox(height: 5,),  Text(condition,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text(value,style: TextStyle(fontSize: 13),)
          ],
        ),
      ),
    );;
  }
}
