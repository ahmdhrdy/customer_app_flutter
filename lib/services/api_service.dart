import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';
import '../models/user.dart';
import 'dart:convert' show utf8; // For encoding

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = "https://www.pqstec.com/InvoiceApps/Values";
  final String imageBaseUrl = "https://www.pqstec.com/InvoiceApps"; // No trailing slash
  String? _token;

  String? get token => _token; // Add getter for token

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Future<User> login(String username, String password, int comId) async {
    final url = Uri.parse('$baseUrl/LogIn?UserName=$username&Password=$password&comId=$comId');
    print('Login Request URL: $url');
    final response = await http.get(url);
    print('Login Response: Status: ${response.statusCode}, Headers: ${response.headers}, Body: ${response.body}');
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('Login failed: Empty response from server');
      }
      try {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('Token')) {
          final user = User.fromJson(data);
          setToken(user.token);
          return user;
        } else {
          throw Exception('Login failed: Invalid response format - $data');
        }
      } catch (e) {
        print('JSON Error: $e - Response: ${response.body}');
        throw Exception('Login failed: Invalid JSON response');
      }
    } else {
      throw Exception('Login failed: Server error (${response.statusCode}) - ${response.body}');
    }
  }

  Future<List<Customer>> getCustomers({
    required int pageNo,
    int pageSize = 20,
    String sortBy = 'Balance',
    String searchQuery = '',
  }) async {
    if (_token == null) {
      throw Exception('Not authenticated. Please log in.');
    }
    final url = Uri.parse(
      '$baseUrl/GetCustomerList?searchquery=$searchQuery&pageNo=$pageNo&pageSize=$pageSize&SortyBy=$sortBy',
    );
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });
    print('GetCustomers Response: Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Success'] == 1 && data['error'] == false) {
        final List<dynamic> customerList = data['CustomerList'] ?? [];
        return customerList.map((json) => Customer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load customers: API error');
      }
    } else {
      throw Exception('Failed to load customers: Server error (${response.statusCode})');
    }
  }

  String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    // Remove leading slash and encode the entire path properly
    String adjustedPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return Uri.parse('$imageBaseUrl/$adjustedPath').toString();
  }
}