
import 'package:ayni_flutter_app/home_screens/models/sensor.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart' as graphic;



class DashboardScreen extends StatelessWidget {
  final Sensor? sensor;
  const DashboardScreen({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Potato'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Container(
              height: 150,
              child: graphic.Chart(
                data: [
                  {'category': 'Oxydenation: ${sensor?.oxygenation}', 'value': sensor?.oxygenation},
                  {'category': 'Hydration: ${sensor?.hydration}', 'value': sensor?.hydration},
                  {'category': 'Water Level: ${sensor?.waterLevel}', 'value': sensor?.waterLevel},
                ],
                variables: {
                  'category': graphic.Variable(
                    accessor: (Map map) => map['category'] as String,
                  ),
                  'value': graphic.Variable(
                    accessor: (Map map) => map['value'] as num,
                    scale: graphic.LinearScale(min: 0, max: 100),
                  ),
                },
                marks: [
                  graphic.IntervalMark(
                    position: graphic.Varset('category') * graphic.Varset('value'),
                    color: graphic.ColorEncode(value: Colors.blue),
                  ),
                ],
                axes: [
                  graphic.Defaults.horizontalAxis,
                  graphic.Defaults.verticalAxis,
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text('Temperatura', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Container(
              height: 150,
              child: graphic.Chart(
                data: [
                  {'date': 'Sep 22', 'temp1': 60, 'temp2': sensor?.temperature},
                  {'date': 'Sep 29', 'temp1': sensor?.temperature, 'temp2': 70},
                  {'date': 'Oct 6', 'temp1': 80, 'temp2': sensor?.temperature},
                ],
                variables: {
                  'date': graphic.Variable(
                    accessor: (Map map) => map['date'] as String,
                  ),
                  'temp1': graphic.Variable(
                    accessor: (Map map) => map['temp1'] as num,
                    scale: graphic.LinearScale(min: 0, max: 100),
                  ),
                  'temp2': graphic.Variable(
                    accessor: (Map map) => map['temp2'] as num,
                    scale: graphic.LinearScale(min: 0, max: 100),
                  ),
                },
                marks: [
                  graphic.LineMark(
                    position: graphic.Varset('date') * graphic.Varset('temp1'),
                    color: graphic.ColorEncode(value: Colors.red),
                  ),
                  graphic.LineMark(
                    position: graphic.Varset('date') * graphic.Varset('temp2'),
                    color: graphic.ColorEncode(value: Colors.blue),
                  ),
                ],
                axes: [
                  graphic.Defaults.horizontalAxis,
                  graphic.Defaults.verticalAxis,
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

