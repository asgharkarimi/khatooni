import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class AddDriverForm extends StatefulWidget {
  @override
  _AddDriverFormState createState() => _AddDriverFormState();
}

class _AddDriverFormState extends State<AddDriverForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _nationalCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  File? _nationalCardImage;
  File? _driverLicenseImage;

  final ImagePicker _picker = ImagePicker();

  // تابع برای انتخاب تصویر
  Future<void> _pickImage(ImageSource source, {bool isNationalCard = true}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isNationalCard) {
          _nationalCardImage = File(pickedFile.path);
        } else {
          _driverLicenseImage = File(pickedFile.path);
        }
      });
    }
  }

  // تابع برای ارسال فرم به سرور
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _nationalCardImage != null && _driverLicenseImage != null) {
      var uri = Uri.parse('http://192.168.188.166/khatoonbar/driver_api.php');
      var request = http.MultipartRequest('POST', uri);

      // اضافه کردن فیلدهای متنی
      request.fields['name'] = _nameController.text;
      request.fields['family_name'] = _familyNameController.text;
      request.fields['national_code'] = _nationalCodeController.text;
      request.fields['phone_number'] = _phoneNumberController.text;
      request.fields['password'] = _passwordController.text;

      // اضافه کردن تصاویر
      request.files.add(await http.MultipartFile.fromPath(
        'national_card_image',
        _nationalCardImage!.path,
      ));
      request.files.add(await http.MultipartFile.fromPath(
        'driver_license_image',
        _driverLicenseImage!.path,
      ));

      // ارسال درخواست
      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('راننده با موفقیت ثبت شد')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطا در ثبت راننده')),
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
        title: Text('ثبت راننده'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextFormField('نام', _nameController, 'لطفاً نام را وارد کنید'),
                    SizedBox(height: 16),
                    _buildTextFormField('نام خانوادگی', _familyNameController, 'لطفاً نام خانوادگی را وارد کنید'),
                    SizedBox(height: 16),
                    _buildTextFormField('کد ملی', _nationalCodeController, 'لطفاً کد ملی را وارد کنید'),
                    SizedBox(height: 16),
                    _buildTextFormField('شماره تلفن', _phoneNumberController, 'لطفاً شماره تلفن را وارد کنید'),
                    SizedBox(height: 16),
                    _buildPasswordField(),
                    SizedBox(height: 16),
                    _buildImageSection('انتخاب عکس کارت ملی', _nationalCardImage, () => _pickImage(ImageSource.gallery, isNationalCard: true)),
                    SizedBox(height: 16),
                    _buildImageSection('انتخاب عکس گواهینامه رانندگی', _driverLicenseImage, () => _pickImage(ImageSource.gallery, isNationalCard: false)),
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
                        'ثبت راننده',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // تابع برای ساخت فیلد تکست
  Widget _buildTextFormField(String label, TextEditingController controller, String validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) => value!.isEmpty ? validationMessage : null,
    );
  }

  // تابع برای ساخت فیلد رمز عبور
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'رمز عبور',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'لطفاً رمز عبور را وارد کنید' : null,
    );
  }

  // تابع برای ساخت بخش تصویر
  Widget _buildImageSection(String label, File? image, VoidCallback onSelectImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (image != null)
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.file(
              image,
              fit: BoxFit.cover,
            ),
          )
        else
          ElevatedButton(
            onPressed: onSelectImage,

            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.teal[200],
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'انتخاب تصویر',
              style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }
}