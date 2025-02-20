import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:khatooni/addcar_form.dart';
import 'package:khatooni/addcargo_form.dart';
import 'package:khatooni/addcustomer_form.dart';
import 'package:khatooni/apptheme.dart';
import 'package:khatooni/addcargotype_form.dart';
import 'package:khatooni/addexpense_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'خاتونی',
      theme: AppTheme.lightTheme,
      locale: const Locale('fa', 'IR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'),
      ],
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.95,
                        children: [
                          MenuCard(
                            icon: Icons.person,
                            label: 'ثبت مشتری',
                            description: 'ثبت اطلاعات مشتری جدید',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddCustomerForm()),
                              );
                            },
                          ),
                          MenuCard(
                            icon: Icons.local_shipping,
                            label: 'ثبت خودرو',
                            description: 'ثبت مشخصات خودرو',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddCarForm()),
                              );
                            },
                          ),
                          MenuCard(
                            icon: Icons.inventory,
                            label: 'ثبت محموله',
                            description: 'ثبت اطلاعات محموله',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddCargoForm()),
                              );
                            },
                          ),
                          MenuCard(
                            icon: Icons.category,
                            label: 'نوع محموله',
                            description: 'تعریف انواع محموله',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddCargoTypeForm()),
                              );
                            },
                          ),
                          MenuCard(
                            icon: Icons.analytics,
                            label: 'گزارش‌ها',
                            description: 'مشاهده گزارش‌های سیستم',
                            onPressed: () {
                              // TODO: Add reports screen
                            },
                          ),
                          MenuCard(
                            icon: Icons.receipt_long,
                            label: 'ثبت هزینه‌ها',
                            description: 'ثبت هزینه‌های سفر',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddExpenseForm()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onPressed;

  const MenuCard({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.lightGreen,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// echo "# khatooni" >> README.md
// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/asgharkarimi/khatooni.git
// git push -u origin main