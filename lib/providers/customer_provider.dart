import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/customer.dart';
import '../services/api_service.dart';
import 'dart:convert';

class CustomerProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<Customer> _customers = [];
  int _pageNo = 1;
  int _pageCount = 1; // Will be updated from API response
  bool _isLoading = false;
  String? _error;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCustomers({bool isLoadMore = false}) async {
    if (_isLoading || (_pageNo > _pageCount && isLoadMore)) return;

    _isLoading = true;
    if (!isLoadMore) _error = null;
    notifyListeners();

    try {
      final token = apiService.token;
      if (token == null) {
        throw Exception('Not authenticated. Please log in.');
      }
      final response = await http.get(
        Uri.parse(
          'https://www.pqstec.com/InvoiceApps/Values/GetCustomerList?searchquery=&pageNo=$_pageNo&pageSize=20&SortyBy=Balance',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      print('FetchCustomers Response for pageNo $_pageNo: Status: ${response.statusCode}, Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Success'] == 1 && data['error'] == false) {
          final List<dynamic> newCustomers = data['CustomerList'] ?? [];
          if (isLoadMore) {
            _customers.addAll(newCustomers.map((json) => Customer.fromJson(json)).toList());
          } else {
            _customers = newCustomers.map((json) => Customer.fromJson(json)).toList();
          }
          _pageNo++;
          _pageCount = data['PageInfo']?['PageCount'] ?? _pageCount; // Safe navigation
        } else {
          throw Exception('Failed to load customers: API error - ${data['Message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load customers: Server error (${response.statusCode})');
      }
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _customers = [];
    _pageNo = 1;
    _pageCount = 1;
    _error = null;
    notifyListeners();
  }
}