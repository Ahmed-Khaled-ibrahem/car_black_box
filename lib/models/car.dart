class Car{
  final String? name;
  final String? model;
  final int? image;
  final String id;
  final String? lat;
  final String? lng;
  final String pass;
  final bool risk;
  final int speed;
  final String? owners;

  Car({
    this.name,
    this.model,
    this.image,
    required this.id,
    this.lat,
    this.lng,
    this.pass = '',
    this.risk = false,
    this.speed = 0,
    this.owners
  });

  static fromJson(MapEntry entry) {
    return Car(
      name: entry.value["name"],
      model: entry.value["model"],
      image: entry.value["image"],
      id: entry.key,
      lat: entry.value["lat"],
      lng: entry.value["lng"],
      pass: entry.value["pass"],
      risk: entry.value["risk"] ?? false,
      speed: entry.value["speed"] ?? 0,
      owners: entry.value["owners"],
    );
  }

}