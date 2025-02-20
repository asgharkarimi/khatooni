import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khatooni/widgets/form_layout.dart';
import 'package:khatooni/widgets/form_section.dart';

class AddCustomerForm extends StatefulWidget {
  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
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
    return FormLayout(
      title: 'ثبت راننده جدید',
      onSubmit: _submitForm,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormSection(
                title: 'اطلاعات شخصی',
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'نام',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'لطفاً نام را وارد کنید' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _familyNameController,
                    decoration: const InputDecoration(
                      labelText: 'نام خانوادگی',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'لطفاً نام خانوادگی را وارد کنید' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'شماره تلفن',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'لطفاً شماره تلفن را وارد کنید' : null,
                  ),
                ],
              ),
              FormSection(
                title: 'اطلاعات مالی',
                children: [
                  TextFormField(
                    controller: _rentalCostController,
                    decoration: const InputDecoration(
                      labelText: 'هزینه اجاره',
                      prefixIcon: Icon(Icons.attach_money),
                      suffixText: 'تومان',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'لطفاً هزینه اجاره را وارد کنید' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cargoPriceController,
                    decoration: const InputDecoration(
                      labelText: 'قیمت بار',
                      prefixIcon: Icon(Icons.local_shipping),
                      suffixText: 'تومان',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'لطفاً قیمت بار را وارد کنید' : null,
                  ),
                ],
              ),
              FormSection(
                title: 'اطلاعات سرویس',
                children: [
                  TextFormField(
                    controller: _serviceNumberController,
                    decoration: const InputDecoration(
                      labelText: 'شماره سرویس',
                      prefixIcon: Icon(Icons.confirmation_number),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'لطفاً شماره سرویس را وارد کنید' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _paymentStatusIdController,
                    decoration: const InputDecoration(
                      labelText: 'وضعیت پرداخت',
                      prefixIcon: Icon(Icons.payment),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'لطفاً وضعیت پرداخت را وارد کنید' : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}