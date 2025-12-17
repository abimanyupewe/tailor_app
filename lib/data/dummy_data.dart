import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/constants/image_string.dart';

class DataTailor {
  DataTailor();

  final List<Map<String, dynamic>> data = [
    {
      'id': 'T001A',
      'name': 'Afad',
      'age': 30,
      'specialty': 'Men\'s Wear',
      'latlong': {'lat': -6.200000, 'long': 106.816666},
      'profilePhoto': 'https://randomuser.me/api/portraits/men/1.jpg',
      'address': 'Jl. Merdeka No. 10, Jakarta',
      'rating': 4.7,
      'experience': 8,
      'isOpen': true,
      'services': ['Jahit Baju', 'Permak Celana', 'Jas Custom'],
      'description':
          'Spesialis pakaian pria, jas custom, dan permak celana. Pelayanan ramah dan hasil jahitan rapi.',
      'range': '2 km',
      'tag': '',
      'active': true,
      'jumlahCustomer': 120,
    },
    {
      'id': 'T002B',
      'name': 'Lina',
      'age': 25,
      'specialty': 'Women\'s Wear',
      'latlong': {'lat': -6.210000, 'long': 106.820000},
      'profilePhoto': 'https://randomuser.me/api/portraits/women/2.jpg',
      'address': 'Jl. Sudirman No. 22, Jakarta',
      'rating': 4.9,
      'experience': 5,
      'isOpen': false,
      'services': ['Jahit Dress', 'Permak Rok', 'Kebaya Custom'],
      'description':
          'Ahli pakaian wanita, dress, kebaya, dan permak rok. Hasil jahitan detail dan fashionable.',
      'range': '1.5 km',
      'tag': '',
      'active': false,
      'jumlahCustomer': 20,
    },
    {
      'id': 'T003C',
      'name': 'Ravi',
      'age': 35,
      'specialty': 'Children\'s Wear',
      'latlong': {'lat': -6.220000, 'long': 106.830000},
      'profilePhoto': 'https://randomuser.me/api/portraits/men/3.jpg',
      'address': 'Jl. Thamrin No. 5, Jakarta',
      'rating': 4.5,
      'experience': 12,
      'isOpen': true,
      'services': ['Jahit Seragam Anak', 'Permak Baju Anak'],
      'description':
          'Spesialis pakaian anak, seragam sekolah, dan permak baju anak. Jahitan kuat dan nyaman dipakai.',
      'range': '2.2 km',
      'tag': '',
      'active': true,
      'jumlahCustomer': 90,
    },
    {
      'id': 'T004D',
      'name': 'Siti',
      'age': 28,
      'specialty': 'Traditional Wear',
      'latlong': {'lat': -6.230000, 'long': 106.840000},
      'profilePhoto': 'https://randomuser.me/api/portraits/women/4.jpg',
      'address': 'Jl. Gatot Subroto No. 15, Jakarta',
      'rating': 4.8,
      'experience': 6,
      'isOpen': true,
      'services': ['Jahit Batik', 'Kebaya Custom', 'Permak Pakaian Adat'],
      'description':
          'Ahli pakaian tradisional, batik, kebaya, dan permak pakaian adat. Jahitan halus dan motif sesuai pesanan.',
      'range': '1.8 km',
      'tag': '',
      'active': true,
      'jumlahCustomer': 89,
    },
    {
      'id': 'T005E',
      'name': 'Budi',
      'age': 32,
      'specialty': 'Men\'s & Women\'s Wear',
      'latlong': {'lat': -6.205000, 'long': 106.815000},
      'profilePhoto': 'https://randomuser.me/api/portraits/men/5.jpg',
      'address': 'Jl. Mangga Dua No. 7, Jakarta',
      'rating': 4.6,
      'experience': 10,
      'isOpen': true,
      'services': ['Jahit Baju', 'Permak Celana', 'Jahit Dress'],
      'description':
          'Penjahit terdekat dengan anda, melayani jahit baju pria & wanita, permak celana, dan dress. Cepat dan hasil memuaskan.',
      'range': '0.5 km',
      'tag': 'terdekat dengan anda',
      'active': true,
      'jumlahCustomer': 200,
    },
    {
      'id': 'T006F',
      'name': 'Dewi',
      'age': 27,
      'specialty': 'Women\'s Wear',
      'latlong': {'lat': -6.206000, 'long': 106.816000},
      'profilePhoto': 'https://randomuser.me/api/portraits/women/6.jpg',
      'address': 'Jl. Melati No. 3, Jakarta',
      'rating': 4.8,
      'experience': 7,
      'isOpen': true,
      'services': ['Jahit Dress', 'Permak Rok', 'Jahit Kebaya'],
      'description':
          'Penjahit wanita terdekat dengan anda, spesialis dress dan kebaya, hasil jahitan detail dan fashionable.',
      'range': '0.7 km',
      'tag': 'terdekat dengan anda',
      'active': true,
      'jumlahCustomer': 110,
    },
    {
      'id': 'T007G',
      'name': 'Andi',
      'age': 29,
      'specialty': 'Men\'s Wear',
      'latlong': {'lat': -6.207000, 'long': 106.817000},
      'profilePhoto': 'https://randomuser.me/api/portraits/men/7.jpg',
      'address': 'Jl. Anggrek No. 8, Jakarta',
      'rating': 4.7,
      'experience': 9,
      'isOpen': true,
      'services': ['Jahit Jas', 'Permak Celana', 'Jahit Kemeja'],
      'description':
          'Penjahit pria terdekat dengan anda, spesialis jas, kemeja, dan permak celana. Pelayanan cepat dan ramah.',
      'range': '0.6 km',
      'tag': 'terdekat dengan anda',
      'active': true,
      'jumlahCustomer': 33,
    },
    {
      'id': 'T006F',
      'name': 'Maya',
      'age': 27,
      'specialty': 'Accessories & Bags',
      'latlong': {'lat': -6.215000, 'long': 106.825000},
      'profilePhoto': 'https://randomuser.me/api/portraits/women/6.jpg',
      'address': 'Jl. Kuningan No. 12, Jakarta',
      'rating': 4.7,
      'experience': 4,
      'isOpen': true,
      'services': ['Jahit Tas', 'Permak Tas', 'Jahit Aksesoris'],
      'description':
          'Ahli dalam menjahit tas dan aksesoris, dengan hasil jahitan yang rapi dan berkualitas.',
      'range': '1 km',
      'tag': '',
      'active': true,
      'jumlahCustomer': 80,
    },
    {
      'id': 'T007G',
      'name': 'Andi',
      'age': 40,
      'specialty': 'Shoes & Footwear',
      'latlong': {'lat': -6.225000, 'long': 106.835000},
      'profilePhoto': 'https://randomuser.me/api/portraits/men/7.jpg',
      'address': 'Jl. Palmerah No. 20, Jakarta',
      'rating': 4.5,
      'experience': 8,
      'isOpen': true,
      'services': ['Jahit Sepatu', 'Permak Sepatu'],
      'description':
          'Spesialis sepatu, jahit dan permak sepatu dengan hasil yang rapi dan berkualitas.',
      'range': '2 km',
      'tag': '',
      'jumlahCustomer': 60,
    },
  ];
}

class DataSlider {
  DataSlider();

  final List<Map<String, dynamic>> data = [
    {
      'id': 'S001',
      'imageUrl': ImageString.banner1,
      'link': '',
      'color': AppColors.pastelBlue,
      'textAction': 'Order Now',
      'title': 'Summer Collection',
      'description':
          'Explore our new summer collection with vibrant colors and styles.',
    },
    {
      'id': 'S002',
      'imageUrl': ImageString.banner2,
      'link': '',
      'color': AppColors.pastelYellow,
      'textAction': 'Explore Now',
      'title': 'Tailoring Services',
      'description':
          'Get your clothes tailored to perfection by our expert tailors.',
    },
    {
      'id': 'S003',
      'imageUrl': ImageString.banner3,
      'link': '',
      'color': AppColors.pastelPurple,
      'textAction': 'Shop Now',
      'title': 'Exclusive Offers',
      'description':
          'Avail exclusive discounts on selected tailoring services this month.',
    },
  ];
}

class DataCategory {
  DataCategory();

  final List<Map<String, dynamic>> data = [
    {
      'id': 'C001',
      'name': 'Wear',
      'iconUrl': ImageString.adultWear,
      'color': AppColors.pastelBlue,
    },
    {
      'id': 'C002',
      'name': 'Traditional Wear',
      'iconUrl': ImageString.traditionalWear,
      'color': AppColors.pastelPink,
    },
    {
      'id': 'C003',
      'name': 'Children\'s Wear',
      'iconUrl': ImageString.childrensWear,
      'color': AppColors.pastelPurple,
    },
    {
      'id': 'C004',
      'name': 'Bags & Accessories',
      'iconUrl': ImageString.bag,
      'color': AppColors.pastelBlue,
    },
    {
      'id': 'C005',
      'name': 'Shoes',
      'iconUrl': ImageString.shoes,
      'color': AppColors.pastelGreen,
    },
  ];
}
