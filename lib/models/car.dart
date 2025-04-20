class Car{
  final String? name;
  final String? model;
  final int? image;
  final String id;
  final double? lat;
  final double? lng;
  final String pass;
  final bool risk;
  final double speed;
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
    final gps = entry.value["gps"];
    late double lat ;
    late double lng ;
    late double speed ;

    if(gps == null) {
      lat = 21.59462;
      lng = 39.26642;
      speed = 0;
    }
    else{
       lat = gps["lat"];
       lng = gps["lng"];
       speed = gps["speed"] ?? 0;
    }

    return Car(
      name: entry.value["name"],
      model: entry.value["model"],
      image: entry.value["image"],
      id: entry.key,
      lat: lat,
      lng: lng,
      pass: entry.value["pass"],
      risk: entry.value["risk"] ?? false,
      speed: speed,
      owners: entry.value["owners"],
    );
  }

}