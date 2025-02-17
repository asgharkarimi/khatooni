import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DriversListScreen extends StatefulWidget {
  @override
  _DriversListScreenState createState() => _DriversListScreenState();
}

class _DriversListScreenState extends State<DriversListScreen> {
  // آدرس API
  final String _apiUrl = 'http://192.168.188.166/khatoonbar/driver_api.php';

  // تابع برای دریافت لیست رانندگان از سرور
  Future<List<Map<String, dynamic>>> _fetchDrivers() async {
    try {
      var response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        // تبدیل پاسخ JSON به لیست
        var data = jsonDecode(response.body);
        if (data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching drivers: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لیست رانندگان'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchDrivers(), // فراخوانی تابع برای دریافت داده‌ها
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // نمایش حالت بارگذاری
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // نمایش خطا
            return Center(child: Text('خطا در بارگیری داده‌ها'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // نمایش پیغام هنگامی که داده‌ای وجود ندارد
            return Center(child: Text('راننده‌ای یافت نشد'));
          }

          // نمایش لیست رانندگان
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> driver = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(driver['name'] ?? 'نامشخص'), // نام راننده
                  subtitle: Text(driver['family_name'] ?? 'نام خانوادگی نامشخص'), // نام خانوادگی راننده
                  trailing: Text(driver['phone_number'] ?? 'شماره تلفن نامشخص'), // شماره تلفن راننده
                ),
              );
            },
          );
        },
      ),
    );
  }
}


