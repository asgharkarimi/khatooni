import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'services/api_service.dart';
import 'package:khatooni/widgets/form_layout.dart';

class AddExpenseForm extends StatefulWidget {
  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Text Controllers
  final TextEditingController _serviceNumberController = TextEditingController();
  final TextEditingController _tollCostController = TextEditingController();
  final TextEditingController _gasoilCostController = TextEditingController();
  final TextEditingController _loadingBonusCostController = TextEditingController();
  final TextEditingController _unloadingBonusCostController = TextEditingController();
  final TextEditingController _disinfectionCostController = TextEditingController();

  // Image Files
  File? _invoiceImage;
  File? _tollImage;
  File? _gasoilImage;
  File? _loadingBonusImage;
  File? _unloadingBonusImage;
  File? _disinfectionImage;

  Future<void> _pickImage(String type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case 'invoice':
            _invoiceImage = File(pickedFile.path);
            break;
          case 'toll':
            _tollImage = File(pickedFile.path);
            break;
          case 'gasoil':
            _gasoilImage = File(pickedFile.path);
            break;
          case 'loading_bonus':
            _loadingBonusImage = File(pickedFile.path);
            break;
          case 'unloading_bonus':
            _unloadingBonusImage = File(pickedFile.path);
            break;
          case 'disinfection':
            _disinfectionImage = File(pickedFile.path);
            break;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var uri = Uri.parse(ApiService.expensesApi);
      var request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields['service_number'] = _serviceNumberController.text;
      request.fields['toll_cost'] = _tollCostController.text;
      request.fields['gasoil_cost'] = _gasoilCostController.text;
      request.fields['loading_bonus_cost'] = _loadingBonusCostController.text;
      request.fields['unloading_bonus_cost'] = _unloadingBonusCostController.text;
      request.fields['disinfection_cost'] = _disinfectionCostController.text;

      // Add image files if they exist
      if (_invoiceImage != null) {
        request.files.add(await http.MultipartFile.fromPath('invoice_image', _invoiceImage!.path));
      }
      if (_tollImage != null) {
        request.files.add(await http.MultipartFile.fromPath('toll_image', _tollImage!.path));
      }
      if (_gasoilImage != null) {
        request.files.add(await http.MultipartFile.fromPath('gasoil_image', _gasoilImage!.path));
      }
      if (_loadingBonusImage != null) {
        request.files.add(await http.MultipartFile.fromPath('loading_bonus_image', _loadingBonusImage!.path));
      }
      if (_unloadingBonusImage != null) {
        request.files.add(await http.MultipartFile.fromPath('unloading_bonus_image', _unloadingBonusImage!.path));
      }
      if (_disinfectionImage != null) {
        request.files.add(await http.MultipartFile.fromPath('disinfection_image', _disinfectionImage!.path));
      }

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('هزینه با موفقیت ثبت شد')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطا در ثبت هزینه')),
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
      title: 'ثبت هزینه‌ها',
      onSubmit: _submitForm,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اطلاعات پایه',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        'شماره سرویس',
                        _serviceNumberController,
                        Icons.confirmation_number,
                      ),
                      _buildImageSection('تصویر فاکتور', _invoiceImage, () => _pickImage('invoice')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'هزینه‌های سفر',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCostSection('عوارضی', _tollCostController, _tollImage, () => _pickImage('toll')),
                      _buildCostSection('گازوئیل', _gasoilCostController, _gasoilImage, () => _pickImage('gasoil')),
                      _buildCostSection('انعام بارگیری', _loadingBonusCostController, _loadingBonusImage, () => _pickImage('loading_bonus')),
                      _buildCostSection('انعام تخلیه', _unloadingBonusCostController, _unloadingBonusImage, () => _pickImage('unloading_bonus')),
                      _buildCostSection('ضدعفونی', _disinfectionCostController, _disinfectionImage, () => _pickImage('disinfection')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller, IconData icon, {bool isCost = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isCost ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'این فیلد الزامی است';
          }
          if (isCost) {
            if (double.tryParse(value!) == null) {
              return 'لطفا یک عدد معتبر وارد کنید';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCostSection(String label, TextEditingController controller, File? image, VoidCallback onPickImage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextFormField('هزینه $label', controller, Icons.attach_money, isCost: true),
          _buildImageSection('تصویر $label', image, onPickImage),
        ],
      ),
    );
  }

  Widget _buildImageSection(String label, File? image, VoidCallback onPickImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        if (image != null)
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(image, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: () => setState(() {
                    switch (label) {
                      case 'تصویر فاکتور':
                        _invoiceImage = null;
                        break;
                      case 'تصویر عوارضی':
                        _tollImage = null;
                        break;
                      // ... handle other cases
                    }
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, size: 20, color: Colors.red[400]),
                  ),
                ),
              ),
            ],
          )
        else
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPickImage,
              icon: Icon(Icons.add_photo_alternate_outlined, color: Colors.black54),
              label: Text('انتخاب تصویر', style: TextStyle(color: Colors.black54)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
} 