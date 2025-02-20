class ApiService {
  static const String baseUrl = 'http://192.168.103.166/khatoonbar/';

  static String getUrl(String endpoint) {
    return baseUrl + endpoint;
  }

  // Common API endpoints
  static String get driverApi => getUrl('driver_api.php');
  static String get carApi => getUrl('car_api.php');
  static String get cargoTypeApi => getUrl('cargo_type_api.php');
  static String get cargoApi => getUrl('cargo_api.php');
  static String get expensesApi => getUrl('expenses_api.php');
  // Add other endpoints as needed
} 