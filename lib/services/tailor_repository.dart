import 'package:tailor_app/models/tailor_model.dart';

class TailorRepository {
  static List<Tailor> getTailors() {
    return [
      Tailor(
        id: '1',
        name: 'Budi Tailor',
        address: 'Jl. Sudirman No. 10, Jakarta',
        rating: 4.8,
        reviewCount: 120,
        imageUrl: 'https://i.pravatar.cc/300?img=11', // Placeholder
        latitude: -6.2088,
        longitude: 106.8456,
        distance: 0.5,
        services: [
          Service(
            name: 'Permak Jeans',
            price: 25000,
            description: 'Potong, kecilkan pinggang',
          ),
          Service(
            name: 'Jahit Kemeja',
            price: 150000,
            description: 'Jahit kemeja pria/wanita custom',
          ),
        ],
        reviews: [
          Review(
            userName: 'Andi',
            rating: 5.0,
            comment: 'Jahitan rapi banget!',
            date: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ],
      ),
      Tailor(
        id: '2',
        name: 'Sari Busana',
        address: 'Jl. Thamrin No. 5, Jakarta',
        rating: 4.5,
        reviewCount: 85,
        imageUrl: 'https://i.pravatar.cc/300?img=5', // Placeholder
        latitude: -6.1900,
        longitude: 106.8200,
        distance: 1.2,
        services: [
          Service(
            name: 'Jahit Kebaya',
            price: 300000,
            description: 'Kebaya wisuda/pesta',
          ),
        ],
        reviews: [],
      ),
      Tailor(
        id: '3',
        name: 'Express Tailor',
        address: 'Jl. Gatot Subroto, Jakarta',
        rating: 4.2,
        reviewCount: 45,
        imageUrl: 'https://i.pravatar.cc/300?img=3', // Placeholder
        latitude: -6.2300,
        longitude: 106.8300,
        distance: 2.5,
        services: [
          Service(
            name: 'Permak Kilat',
            price: 35000,
            description: '1 jam jadi',
          ),
        ],
        reviews: [],
      ),
    ];
  }
}
