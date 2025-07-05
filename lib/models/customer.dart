import 'dart:convert';

class Customer {
  final int id;
  final String name;
  final String? email;
  final String? primaryAddress;
  final String? secoundaryAddress;
  final String? notes;
  final String? phone;
  final String? custType;
  final String? parentCustomer;
  final String? imagePath;
  final double totalDue;
  final String? lastSalesDate;
  final String? lastInvoiceNo;
  final String? lastSoldProduct;
  final double totalSalesValue;
  final double totalSalesReturnValue;
  final double totalAmountBack;
  final double totalCollection;
  final String? lastTransactionDate;
  final String? clientCompanyName;

  Customer({
    required this.id,
    required this.name,
    this.email,
    this.primaryAddress,
    this.secoundaryAddress,
    this.notes,
    this.phone,
    this.custType,
    this.parentCustomer,
    this.imagePath,
    required this.totalDue,
    this.lastSalesDate,
    this.lastInvoiceNo,
    this.lastSoldProduct,
    required this.totalSalesValue,
    required this.totalSalesReturnValue,
    required this.totalAmountBack,
    required this.totalCollection,
    this.lastTransactionDate,
    this.clientCompanyName,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['Id'],
      name: json['Name'],
      email: json['Email'],
      primaryAddress: json['PrimaryAddress'],
      secoundaryAddress: json['SecoundaryAddress'],
      notes: json['Notes'],
      phone: json['Phone'],
      custType: json['CustType'],
      parentCustomer: json['ParentCustomer'],
      imagePath: json['ImagePath'],
      totalDue: (json['TotalDue'] ?? 0.0).toDouble(),
      lastSalesDate: json['LastSalesDate'],
      lastInvoiceNo: json['LastInvoiceNo'],
      lastSoldProduct: json['LastSoldProduct'],
      totalSalesValue: (json['TotalSalesValue'] ?? 0.0).toDouble(),
      totalSalesReturnValue: (json['TotalSalesReturnValue'] ?? 0.0).toDouble(),
      totalAmountBack: (json['TotalAmountBack'] ?? 0.0).toDouble(),
      totalCollection: (json['TotalCollection'] ?? 0.0).toDouble(),
      lastTransactionDate: json['LastTransactionDate'],
      clientCompanyName: json['ClinetCompanyName'], // Assuming typo in API
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Email': email,
      'PrimaryAddress': primaryAddress,
      'SecoundaryAddress': secoundaryAddress,
      'Notes': notes,
      'Phone': phone,
      'CustType': custType,
      'ParentCustomer': parentCustomer,
      'ImagePath': imagePath,
      'TotalDue': totalDue,
      'LastSalesDate': lastSalesDate,
      'LastInvoiceNo': lastInvoiceNo,
      'LastSoldProduct': lastSoldProduct,
      'TotalSalesValue': totalSalesValue,
      'TotalSalesReturnValue': totalSalesReturnValue,
      'TotalAmountBack': totalAmountBack,
      'TotalCollection': totalCollection,
      'LastTransactionDate': lastTransactionDate,
      'ClinetCompanyName': clientCompanyName,
    };
  }
}