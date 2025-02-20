import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'services/api_service.dart';
import 'widgets/form_layout.dart';

class AddCargoTypeForm extends StatefulWidget {
  @override
  _AddCargoTypeFormState createState() => _AddCargoTypeFormState();
}

class _AddCargoTypeFormState extends State<AddCargoTypeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cargoTypeController = TextEditingController();

  // تابع برای ارسال فرم به سرور
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String cargoType = _cargoTypeController.text;

      // Using ApiService for the URL
      var uri = Uri.parse(ApiService.cargoTypeApi);

      // ارسال درخواست POST
      try {
        var response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'cargo_type': cargoType,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('نوع بار با موفقیت ثبت شد')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطا در ثبت نوع بار')),
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
      title: 'ثبت نوع بار',
      onSubmit: _submitForm,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _cargoTypeController,
                decoration: InputDecoration(
                  labelText: 'نام نوع بار',
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'لطفاً نام نوع بار را وارد کنید' : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}