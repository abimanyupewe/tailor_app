class Tailor {
  const Tailor({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.age,
    required this.specialty,
    required this.latlong,
    required this.profilePhoto,
    required this.address,
    required this.experience,
    required this.isOpen,
    required this.services,
    required this.range,
    required this.tag,
    required this.jumlahCustomer,
  });

  final String id;
  final String name;
  final String description;
  final double rating;
  final int age;
  final String specialty;
  final Map<String, double> latlong;
  final String profilePhoto;
  final String address;
  final int experience;
  final bool isOpen;
  final List<String> services;
  final String range;
  final String tag;
  final int jumlahCustomer;
}
