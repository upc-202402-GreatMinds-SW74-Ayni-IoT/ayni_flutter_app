

class Sensor {
  final int id;
  final double temperature;
  final double hydration;
  final double oxygenation;
  final double waterLevel;
  final int cropId;

  const Sensor(
      {required this.id,
        required this.temperature,
        required this.hydration,
        required this.oxygenation,
        required this.waterLevel,
        required this.cropId});

  Sensor.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        temperature = map["temperature"],
        hydration = map["hydration"],
        oxygenation = map["oxygenation"],
        waterLevel = map["waterLevel"],
        cropId = map["cropId"];
}