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
  final String? userId;
  final String phoneNumber;
  final List<Post> posts;

  factory Tailor.fromJson(Map<String, dynamic> json) {
    return Tailor(
      id: json['id']?.toString() ?? json['user']?['id']?.toString() ?? '',
      userId: json['user']?['id']?.toString(), // Can be null
      name: json['shop_name'] ?? 'Unknown Shop',
      address: json['location']?['address'] ?? 'No Address',
      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      reviewCount: int.tryParse(json['review_count']?.toString() ?? '0') ?? 0,
      imageUrl: json['shop_image'] ?? json['user']?['avatar'] ?? '',
      latitude: json['location']?['latitude'] != null
          ? double.tryParse(json['location']['latitude'].toString()) ?? 0.0
          : 0.0,
      longitude: json['location']?['longitude'] != null
          ? double.tryParse(json['location']['longitude'].toString()) ?? 0.0
          : 0.0,
      distance: double.tryParse(json['distance']?.toString() ?? '0.0') ?? 0.0,
      services:
          (json['services'] as List<dynamic>?)
              ?.map((s) => Service.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((r) => Review.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      phoneNumber: json['user']?['phone_number'] ?? '-',
      posts:
          (json['posts'] as List<dynamic>?)
              ?.map((p) => Post.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get formattedDistance {
    if (distance < 1.0) {
      return '${(distance * 1000).toInt()} m';
    } else {
      return '${distance.toStringAsFixed(1)} km';
    }
  }

  Tailor({
    required this.id,
    this.userId,
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
    required this.phoneNumber,
    required this.posts,
  });
}

class Service {
  final int id;
  final String name;
  final double price;
  final String description;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? 'Unknown Service',
      price:
          double.tryParse(
            json['price']?.toString() ??
                json['base_price']?.toString() ??
                '0.0',
          ) ??
          0.0,
      description: json['description'] ?? '',
    );
  }
}

class Review {
  final String userName;
  final String? userAvatar;
  final String serviceName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.userName,
    this.userAvatar,
    required this.serviceName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['user'] != null && json['user']['username'] != null
          ? json['user']['username'].toString()
          : 'Anonymous',
      userAvatar: json['user']?['avatar'],
      serviceName: json['service_name'] ?? 'Tailor Service',
      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      comment: json['comment'] ?? '',
      date: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class Post {
  final int id;
  final String image;
  final String caption;

  Post({required this.id, required this.image, required this.caption});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      image: json['image'] ?? '',
      caption: json['caption'] ?? '',
    );
  }
}
