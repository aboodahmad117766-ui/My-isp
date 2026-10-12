import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MYISP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  String pageTitle = 'لوحة التحكم';

  final List<String> menuItems = [
    'لوحة التحكم',
    'المشتركون',
    'الأجهزة',
    'الاشتراكات والتجديد',
    'الحسابات والأرباح',
    'التنبيهات',
    'المجموعات',
    'الموظفون',
    'فحص الاتصال Ping',
    'سجل العمليات',
    'الإعدادات',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1F6FEB),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.wifi, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'إدارة شبكة الإنترنت',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ...menuItems.asMap().entries.map((entry) {
              int idx = entry.key;
              String title = entry.value;
              return ListTile(
                leading: const Icon(Icons.circle, size: 12, color: Colors.grey),
                title: Text(title),
                selected: currentIndex == idx,
                selectedTileColor: const Color(0xFF1F6FEB).withOpacity(0.3),
                onTap: () {
                  setState(() {
                    currentIndex = idx;
                    pageTitle = title;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
      body: currentIndex == 0 ? buildDashboard() : buildPlaceholder(),
    );
  }

  // لوحة التحكم
  Widget buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('نظرة عامة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: buildStatCard('المشتركون', '0', Icons.people, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: buildStatCard('النشطون', '0', Icons.check_circle, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: buildStatCard('المنتهون', '0', Icons.cancel, Colors.red)),
              const SizedBox(width: 12),
              Expanded(child: buildStatCard('دخل اليوم', '0', Icons.money, Colors.orange)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('آخر الدفعات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: const Center(
              child: Text('لا يوجد دفعات مسجلة', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  // كرت الإحصائيات
  Widget buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              Icon(icon, color: color, size: 22),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // الصفحات قيد الإنشاء
  Widget buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text('صفحة "$pageTitle" قيد الإنشاء', style: const TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}