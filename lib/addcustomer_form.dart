import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCustomerForm extends StatefulWidget {
  @override
  _AddCustomerFormState createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _rentalCostController = TextEditingController();
  final TextEditingController _cargoPriceController = TextEditingController();
  final TextEditingController _paymentStatusIdController = TextEditingController();
  final TextEditingController _serviceNumberController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare the JSON data
      Map<String, String> requestBody = {
        "name": _nameController.text,
        "family_name": _familyNameController.text,
        "phone_number": _phoneNumberController.text,
        "rental_cost": _rentalCostController.text,
        "cargo_price": _cargoPriceController.text,
        "payment_status_id": _paymentStatusIdController.text,
        "service_number": _serviceNumberController.text,
      };

      // Print the JSON data for debugging
      print('Generated JSON: ${jsonEncode(requestBody)}');

      // Send the POST request
      var uri = Uri.parse('http://192.168.188.166/khatoonbar/customer_api.php');
      try {
        var response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody), // Encode the data to JSON
        );

        // Handle the response
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('مشتری با موفقیت ثبت شد')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطا در ثبت مشتری')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطای شبکه: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ثبت مشتری جدید'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextFormField('نام', _nameController, Icons.person),
                _buildTextFormField('نام خانوادگی', _familyNameController, Icons.person_outline),
                _buildTextFormField('شماره تلفن', _phoneNumberController, Icons.phone),
                _buildTextFormField('هزینه اجاره', _rentalCostController, Icons.attach_money),
                _buildTextFormField('قیمت بار', _cargoPriceController, Icons.local_shipping),
                _buildTextFormField('وضعیت پرداخت', _paymentStatusIdController, Icons.payment),
                _buildTextFormField('شماره سرویس', _serviceNumberController, Icons.confirmation_number),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('ثبت مشتری', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'لطفاً این فیلد را پر کنید';
          }
          return null;
        },
      ),
    );
  }
}