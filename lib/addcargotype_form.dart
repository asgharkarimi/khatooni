import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

      // آدرس API
      var uri = Uri.parse('http://192.168.188.166/khatoonbar/cargo_type_api.php');

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
    return Scaffold(
      appBar: AppBar(
        title: Text('ثبت نوع بار'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _cargoTypeController,
                decoration: InputDecoration(
                  labelText: 'نام نوع بار',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? 'لطفاً نام نوع بار را وارد کنید' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'ثبت نوع بار',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}