class Tailor {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final double distance; // Mock distance in km
  final List<Service> services;
  final List<Review> reviews;

  Tailor({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.services,
    required this.reviews,
  });
}

class Service {
  final String name;
  final double price;
  final String description;

  Service({required this.name, required this.price, required this.description});
}

class Review {
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
