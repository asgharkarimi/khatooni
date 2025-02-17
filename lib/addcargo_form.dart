import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCargoForm extends StatefulWidget {
  @override
  _AddCargoFormState createState() => _AddCargoFormState();
}

class _AddCargoFormState extends State<AddCargoForm> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _cars = [];
  List<Map<String, dynamic>> _drivers = [];
  List<Map<String, dynamic>> _cargoTypes = [];

  Map<String, dynamic>? _selectedCar;
  Map<String, dynamic>? _selectedDriver;
  Map<String, dynamic>? _selectedCargoType;

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _pricePerTonController = TextEditingController();
  final TextEditingController _paymentStatusIdController = TextEditingController();
  final TextEditingController _serviceNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCars();
    _fetchDrivers();
    _fetchCargoTypes();
  }

  Future<void> _fetchCars() async {
    var uri = Uri.parse('http://192.168.188.166/khatoonbar/car_api.php');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          _cars = List<Map<String, dynamic>>.from(jsonDecode(response.body)['data'] ?? []);
        });
      }
    } catch (e) {
      print('Error fetching cars: $e');
    }
  }

  Future<void> _fetchDrivers() async {
    var uri = Uri.parse('http://192.168.188.166/khatoonbar/driver_api.php');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          _drivers = List<Map<String, dynamic>>.from(jsonDecode(response.body)['data'] ?? []);
        });
      }
    } catch (e) {
      print('Error fetching drivers: $e');
    }
  }

  Future<void> _fetchCargoTypes() async {
    var uri = Uri.parse('http://192.168.188.166/khatoonbar/cargo_type_api.php');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          _cargoTypes = List<Map<String, dynamic>>.from(jsonDecode(response.body)['data'] ?? []);
        });
      }
    } catch (e) {
      print('Error fetching cargo types: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCar == null || _selectedDriver == null || _selectedCargoType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لطفاً همه گزینه‌ها را انتخاب کنید')),
        );
        return;
      }

      var uri = Uri.parse('http://192.168.188.166/khatoonbar/cargo_api.php');

      try {
        var response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'car_id': _selectedCar!['id'].toString(),
            'driver_id': _selectedDriver!['id'].toString(),
            'cargo_type_id': _selectedCargoType!['id'].toString(),
            'origin': _originController.text,
            'destination': _destinationController.text,
            'date': _dateController.text,
            'weight': _weightController.text,
            'price_per_ton': _pricePerTonController.text,
            'payment_status_id': _paymentStatusIdController.text,
            'service_number': _serviceNumberController.text,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('بار با موفقیت ثبت شد')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطا در ثبت بار')),
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
      appBar: AppBar(title: Text('ثبت بار'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDropdownField('ماشین', _cars, _selectedCar, Icons.directions_car, (value) {
                      setState(() => _selectedCar = value);
                    }),
                    _buildDropdownField('راننده', _drivers, _selectedDriver, Icons.person, (value) {
                      setState(() => _selectedDriver = value);
                    }),
                    _buildDropdownField('نوع بار', _cargoTypes, _selectedCargoType, Icons.category, (value) {
                      setState(() => _selectedCargoType = value);
                    }),
                    _buildTextFormField('مبدا', _originController, Icons.location_on),
                    _buildTextFormField('مقصد', _destinationController, Icons.flag),
                    _buildTextFormField('تاریخ', _dateController, Icons.calendar_today),
                    _buildTextFormField('وزن (تن)', _weightController, Icons.scale),
                    _buildTextFormField('قیمت هر تن', _pricePerTonController, Icons.attach_money),
                    _buildTextFormField('وضعیت پرداخت', _paymentStatusIdController, Icons.payment),
                    _buildTextFormField('شماره سرویس', _serviceNumberController, Icons.confirmation_number),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('ثبت بار', style: TextStyle(fontSize: 18, color: Colors.white)),
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

  Widget _buildDropdownField(String label, List<Map<String, dynamic>> items, Map<String, dynamic>? selectedValue, IconData icon, Function(Map<String, dynamic>?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<Map<String, dynamic>>(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem<Map<String, dynamic>>(
            value: item,
            child: Text(item['car_name'] ?? item['name'] ?? item['cargo_type'] ?? 'نامشخص'),
          );
        }).toList(),
        onChanged: onChanged,
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
      ),
    );
  }
}
