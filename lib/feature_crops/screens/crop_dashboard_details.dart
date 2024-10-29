import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart' as graphic;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                  {'category': 'Fertilizante', 'value': 10},
                  {'category': 'Oxigenación', 'value': 25},
                  {'category': 'Gérmenes', 'value': 80},
                  {'category': 'Conductividad', 'value': 50},
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
                  {'date': 'Sep 22', 'temp1': 60, 'temp2': 62},
                  {'date': 'Sep 29', 'temp1': 75, 'temp2': 70},
                  {'date': 'Oct 6', 'temp1': 80, 'temp2': 78},
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

