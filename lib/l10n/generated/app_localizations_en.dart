// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tailor App';

  @override
  String get navHome => 'Home';

  @override
  String get navMap => 'Map';

  @override
  String get navOrders => 'Orders';

  @override
  String get navChat => 'Chat';

  @override
  String get navProfile => 'Profile';

  @override
  String get greetingMorning => 'Good Morning';

  @override
  String get greetingAfternoon => 'Good Afternoon';

  @override
  String get greetingEvening => 'Good Evening';

  @override
  String get findingLocation => 'Finding location...';

  @override
  String get searchHint => 'Find your perfect tailor...';

  @override
  String get categories => 'Categories';

  @override
  String get seeAll => 'See All';

  @override
  String get closestToYou => 'Closest to you';

  @override
  String get popularTailors => 'Popular Tailors';

  @override
  String get recommended => 'Recommended';

  @override
  String get account => 'Account';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get general => 'General';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get support => 'Support';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get aboutApp => 'About App';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get cancel => 'Cancel';

  @override
  String get personalInfoTitle => 'Personal Information';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get welcomeBack => 'Welcome Back.';

  @override
  String get signInSubtitle => 'Please sign in to your account.';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameHint => 'Enter your username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account.';

  @override
  String get signUpSubtitle => 'Sign up to get started.';

  @override
  String get usernameHintRegister => 'Choose a username';

  @override
  String get passwordHintRegister => 'Create a password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get registerButton => 'Register';

  @override
  String get haveAccount => 'Already have an account? ';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get noMessages => 'No messages yet';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get qrOrderReady => 'Is my order ready?';

  @override
  String get qrEstimate => 'How long is the estimated work?';

  @override
  String get qrResize => 'I want to request a size change.';

  @override
  String get qrThanks => 'Thank you!';

  @override
  String get qrDelivery => 'When can it be delivered?';

  @override
  String get exploreTailors => 'Explore Tailors';

  @override
  String get searchNameHint => 'Search by name...';

  @override
  String get all => 'All';

  @override
  String get noTailorsFound => 'No tailors found';

  @override
  String get allCategories => 'All Categories';

  @override
  String get nearbyTailors => 'Nearby Tailors';

  @override
  String get searchLocationHint => 'Search location...';

  @override
  String get tailorShop => 'Tailor Shop';

  @override
  String get yourLocation => 'Your Location';

  @override
  String get detectingLocation => 'Detecting location...';

  @override
  String get yourDestination => 'Your Destination';

  @override
  String get arrivedTitle => 'You have arrived!';

  @override
  String arrivedBody(String name) {
    return 'You have reached $name location.';
  }

  @override
  String get giveRating => 'Give Rating & Review';

  @override
  String get close => 'Close';

  @override
  String get stopRouting => 'Stop Routing';

  @override
  String get viewRoute => 'View Route';

  @override
  String get tailorService => 'Tailor Service';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get emailLabel => 'Email';

  @override
  String get addressLabel => 'Address';

  @override
  String get save => 'Save';

  @override
  String get chooseGallery => 'Choose from Gallery';

  @override
  String get takePhoto => 'Take a Photo';

  @override
  String get openNow => 'Open Now';

  @override
  String kmAway(String distance) {
    return '$distance km away';
  }

  @override
  String get tabService => 'Service';

  @override
  String get tabPosts => 'Post';

  @override
  String get tabRating => 'Rating';

  @override
  String get tabContact => 'Contact';

  @override
  String get bookNow => 'Book Now';

  @override
  String get noServices => 'No services available';

  @override
  String get noPosts => 'No posts yet';

  @override
  String get noReviews => 'No reviews yet';

  @override
  String get locationAddress => 'Location Address';

  @override
  String callPhone(String phone) {
    return 'Call $phone';
  }

  @override
  String couldNotLaunch(String uri) {
    return 'Could not launch $uri';
  }

  @override
  String get rateExperience => 'Rate your experience';

  @override
  String get commentHint => 'Write a comment (optional)...';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get reviewExists => 'Review Exists';

  @override
  String get alreadyReviewed => 'You have already reviewed this order.';

  @override
  String get reviewSubmitted => 'Review submitted successfully!';

  @override
  String get myOrders => 'My Orders';

  @override
  String get tabPayment => 'Payment';

  @override
  String get tabInProgress => 'In Progress';

  @override
  String get tabHistory => 'History';

  @override
  String get noPendingPayments => 'No pending payments';

  @override
  String get noOrdersProgress => 'No orders in progress';

  @override
  String get noOrderHistory => 'No order history';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String errorParsing(String error) {
    return 'Error parsing data: $error';
  }

  @override
  String get checkMyOrders => 'Check \'My Orders\' to complete payment.';

  @override
  String get transactionDetails => 'Transaction Details';

  @override
  String get serviceProvider => 'Service Provider';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get paymentStatus => 'Payment Status';

  @override
  String get paid => 'PAID';

  @override
  String get awaitingPayment => 'AWAITING PAYMENT';

  @override
  String get unpaid => 'UNPAID';

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get bookService => 'Book Service';

  @override
  String get selectDateServices => 'Please select date & services';

  @override
  String get selectDate => 'Select Date';

  @override
  String get appointmentDate => 'Date of Appointment';

  @override
  String get selectServices => 'Select Services';

  @override
  String get notesHint => 'Add specific notes (e.g. Size, Color)...';

  @override
  String get totalEstimate => 'Total Estimate';

  @override
  String bookNowCount(int count) {
    return 'Book Now ($count)';
  }

  @override
  String orderNumber(int id) {
    return 'Order #$id';
  }

  @override
  String itemsCount(int count) {
    return '$count Items';
  }

  @override
  String get noItems => 'No Items';

  @override
  String get totalPrice => 'Total Price';

  @override
  String get reviewButton => 'Review';

  @override
  String get obTitle1 => 'Find Your Tailor';

  @override
  String get obDesc1 =>
      'Easily find the best professional tailors near you with just a few clicks.';

  @override
  String get obTitle2 => 'Custom Measurements';

  @override
  String get obDesc2 =>
      'Provide your exact measurements online or book an appointment for measuring.';

  @override
  String get obTitle3 => 'Fast Delivery';

  @override
  String get obDesc3 =>
      'Get your custom clothes delivered right to your doorstep, hassle-free.';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';
}
