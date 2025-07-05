import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/customer_provider.dart';
import '../models/customer.dart';
import '../services/api_service.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    customerProvider.reset();
    customerProvider.fetchCustomers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        customerProvider.fetchCustomers(isLoadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<CustomerProvider>(context, listen: false).reset();
              Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
            },
          ),
        ],
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, customerProvider, child) {
          if (customerProvider.isLoading && customerProvider.customers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (customerProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    customerProvider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => customerProvider.fetchCustomers(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (customerProvider.customers.isEmpty) {
            return const Center(child: Text('No customers found'));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: customerProvider.customers.length +
                (customerProvider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == customerProvider.customers.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final customer = customerProvider.customers[index];
              final imageUrl = _apiService.getFullImageUrl(customer.imagePath);
              print('Attempting to load image for ${customer.name}: $imageUrl');
              return ListTile(
                leading: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Image load failed for ${customer.name}: $error, Stack: $stackTrace');
                    return const Icon(Icons.person, size: 50);
                  },
                )
                    : const Icon(Icons.person, size: 50),
                title: Text(customer.name),
                subtitle: Text('ID: ${customer.id} | Due: ৳${customer.totalDue.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.pushNamed(context, '/customer_details', arguments: customer);
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}