import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khatooni/widgets/form_layout.dart';
import 'package:khatooni/widgets/form_section.dart';
import 'services/api_service.dart';

class AddCarForm extends StatefulWidget {
  @override
  State<AddCarForm> createState() => _AddCarFormState();
}

class _AddCarFormState extends State<AddCarForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();

  // تابع برای ارسال فرم به سرور
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String carName = _carNameController.text;
      String plateNumber = _plateNumberController.text;

      // Using ApiService for the URL
      var uri = Uri.parse(ApiService.carApi);

      // ارسال درخواست POST
      try {
        var response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'car_name': carName,
            'plate_number': plateNumber,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ماشین با موفقیت ثبت شد')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطا در ثبت ماشین')),
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
      title: 'ثبت خودرو جدید',
      onSubmit: _submitForm,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormSection(
                title: 'مشخصات خودرو',
                children: [
                  TextFormField(
                    controller: _carNameController,
                    decoration: const InputDecoration(
                      labelText: 'نام ماشین',
                      prefixIcon: Icon(Icons.car_rental),
                      hintText: 'مثال: کامیون ایسوزو',
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'لطفاً نام ماشین را وارد کنید' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _plateNumberController,
                    decoration: const InputDecoration(
                      labelText: 'شماره پلاک',
                      prefixIcon: Icon(Icons.numbers),
                      hintText: 'مثال: 12ع345-78',
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'لطفاً شماره پلاک را وارد کنید' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'نوع خودرو',
                      prefixIcon: Icon(Icons.local_shipping),
                      hintText: 'مثال: کامیون باری',
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'لطفاً نوع خودرو را وارد کنید' : null,
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