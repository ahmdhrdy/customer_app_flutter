import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/api_service.dart';

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = ModalRoute.of(context)!.settings.arguments as Customer;
    final apiService = ApiService(); // Instantiate locally
    final imageUrl = apiService.getFullImageUrl(customer.imagePath);
    print('Attempting to load details image for ${customer.name}: $imageUrl');
    return Scaffold(
      appBar: AppBar(title: Text(customer.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Image load failed for ${customer.name}: $error, Stack: $stackTrace');
                  return const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              )
            else
              const Icon(
                Icons.person,
                size: 100,
                color: Colors.grey,
              ),
            const SizedBox(height: 24),
            _buildDetailRow('ID', customer.id.toString()),
            _buildDetailRow('Name', customer.name),
            _buildDetailRow('Email', customer.email ?? 'N/A'),
            _buildDetailRow('Primary Address', customer.primaryAddress ?? 'N/A'),
            _buildDetailRow('Secondary Address', customer.secoundaryAddress ?? 'N/A'),
            _buildDetailRow('Notes', customer.notes ?? 'N/A'),
            _buildDetailRow('Phone', customer.phone ?? 'N/A'),
            _buildDetailRow('Customer Type', customer.custType ?? 'N/A'),
            _buildDetailRow('Parent Customer', customer.parentCustomer ?? 'N/A'),
            _buildDetailRow('Image Path', customer.imagePath ?? 'N/A'),
            _buildDetailRow('Total Due', '৳${customer.totalDue.toStringAsFixed(2)}'),
            _buildDetailRow('Last Sales Date', customer.lastSalesDate ?? 'N/A'),
            _buildDetailRow('Last Invoice No', customer.lastInvoiceNo ?? 'N/A'),
            _buildDetailRow('Last Sold Product', customer.lastSoldProduct ?? 'N/A'),
            _buildDetailRow('Total Sales Value', '৳${customer.totalSalesValue.toStringAsFixed(2)}'),
            _buildDetailRow('Total Sales Return Value', '৳${customer.totalSalesReturnValue.toStringAsFixed(2)}'),
            _buildDetailRow('Total Amount Back', '৳${customer.totalAmountBack.toStringAsFixed(2)}'),
            _buildDetailRow('Total Collection', '৳${customer.totalCollection.toStringAsFixed(2)}'),
            _buildDetailRow('Last Transaction Date', customer.lastTransactionDate ?? 'N/A'),
            _buildDetailRow('Client Company Name', customer.clientCompanyName ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}