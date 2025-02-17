import 'package:flutter/material.dart';

import 'driver.dart';
import 'package:http/http.dart' as http;

class DriverDropdown extends StatefulWidget {
  @override
  _DriverDropdownState createState() => _DriverDropdownState();
}

class _DriverDropdownState extends State<DriverDropdown> {
  late Future<List<Driver>> drivers;
  Driver? selectedDriver;

  @override
  void initState() {
    super.initState();
    drivers = fetchDrivers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Driver")),
      body: Center(
        child: FutureBuilder<List<Driver>>(
          future: drivers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No drivers found');
            }

            return DropdownButton<Driver>(
              value: selectedDriver,
              hint: Text("Select a driver"),
              onChanged: (Driver? newValue) {
                setState(() {
                  selectedDriver = newValue;
                });
              },
              items: snapshot.data!.map<DropdownMenuItem<Driver>>((Driver driver) {
                return DropdownMenuItem<Driver>(
                  value: driver,
                  child: Text('${driver.name} ${driver.familyName}'),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}


Future<List<Driver>> fetchDrivers() async {
  final response = await http.get(Uri.parse('http://192.168.188.166/khatoonbar/driver_api.php'));

  if (response.statusCode == 200) {
    return Driver.fromJsonList(response.body);
  } else {
    throw Exception('Failed to load drivers');
  }
}
