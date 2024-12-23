import 'package:ayni_flutter_app/feature_crops/screens/crop_dashboard_details.dart';
import 'package:ayni_flutter_app/feature_profile/screens/profile_screen.dart';


import 'package:ayni_flutter_app/home_screens/models/products.dart';
import 'package:ayni_flutter_app/home_screens/models/sensor.dart';
import 'package:ayni_flutter_app/home_screens/screens/crops_list_screen.dart';
import 'package:ayni_flutter_app/home_screens/screens/products_list_screen.dart';
import 'package:ayni_flutter_app/feature_orders/screens/sales_list_screen.dart';
import 'package:ayni_flutter_app/home_screens/services/sensor_service.dart';
import 'package:ayni_flutter_app/shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';


class CropDetailsScreen extends StatefulWidget {
  const CropDetailsScreen(
      {super.key, required this.product});

  final Products product;

  @override
  _CropDetailsScreenState createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen>{
  Sensor? sensor = null;
  final SensorService _sensorService = SensorService();

  @override
  void initState() {
    super.initState();
    _FindSensor();

  }

  Future<void> _FindSensor() async {
    try {
      print("Buscando Sensor con ID: ${widget.product.id}");
      final aux_sensor = await _sensorService.getSensorById(widget.product.id);

      if (aux_sensor == null) {
        print("El servicio no devolvió ningún sensor.");
      } else {
        print("Sensor encontrado: ${aux_sensor.id}");
      }

      setState(() {
        sensor = aux_sensor;
      });
    } catch (e) {
      print("Error en _FindSensor: $e");
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.product.name)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.product.imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Plant Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DetailRow(label: "Distance", value: widget.product.recommendedCultivationDistance),
              DetailRow(label: "Depth", value: widget.product.recommendedCultivationDepth),
              DetailRow(label: "Weather", value: widget.product.recommendedGrowingClimate),
              DetailRow(label: "Soil", value: widget.product.recommendedSoilType),
              DetailRow(label: "Season", value: widget.product.recommendedGrowingSeason),
              const SizedBox(height: 16),

              const Divider(thickness: 1),

              const SizedBox(height: 16),
              const Text(
                "Plant Description",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.description,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (sensor == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No se ha cargado el cultivo aún.")),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(sensor: sensor!),
              ),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.skip_next, color: Colors.white),
        ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0, 
        onTap: (index){
          switch(index){
            case 0:
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const ProductsListScreen()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const CropsListScreen()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const SalesListScreen()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const ProfileScreen()));
              break;
          }
        }),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
