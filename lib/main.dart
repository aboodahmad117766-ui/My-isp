import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF161B22)),
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1F6FEB)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.wifi, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text('إدارة شبكة الإنترنت', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
      body: currentIndex == 0
          ? buildDashboard()
          : currentIndex == 1
              ? const SubscribersPage()
              : buildPlaceholder(),
    );
  }

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
        ],
      ),
    );
  }

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

// ==================== شاشة المشتركين (مع الحفظ المحلي) ====================
class SubscribersPage extends StatefulWidget {
  const SubscribersPage({Key? key}) : super(key: key);

  @override
  State<SubscribersPage> createState() => _SubscribersPageState();
}

class _SubscribersPageState extends State<SubscribersPage> {
  List<Map<String, dynamic>> subscribers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSubscribers();
  }

  // تحميل البيانات من ذاكرة الهاتف
  Future<void> loadSubscribers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('subscribers');
    if (jsonString != null) {
      setState(() {
        subscribers = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
        isLoading = false;
      });
    } else {
      setState(() {
        subscribers = [];
        isLoading = false;
      });
    }
  }

  // حفظ البيانات في ذاكرة الهاتف
  Future<void> saveSubscribers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subscribers', jsonEncode(subscribers));
  }

  // حذف مشترك
  Future<void> deleteSubscriber(int id) async {
    setState(() {
      subscribers.removeWhere((element) => element['id'] == id);
    });
    await saveSubscribers();
  }

  // إظهار نافذة إضافة مشترك
  void showAddDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final planController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('إضافة مشترك جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'الاسم')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'الهاتف')),
              TextField(controller: planController, decoration: const InputDecoration(labelText: 'الخطة')),
              TextField(controller: amountController, decoration: const InputDecoration(labelText: 'المبلغ'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              
              final newSub = {
                'id': DateTime.now().millisecondsSinceEpoch, // معرّف فريد
                'name': nameController.text,
                'phone': phoneController.text,
                'plan': planController.text,
                'amount': double.tryParse(amountController.text) ?? 0,
                'end_date': '2024-12-31',
                'status': 'active',
              };

              setState(() {
                subscribers.add(newSub);
              });
              
              await saveSubscribers();
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : subscribers.isEmpty
              ? const Center(child: Text('لا يوجد مشتركون. اضغط + للإضافة'))
              : ListView.builder(
                  itemCount: subscribers.length,
                  itemBuilder: (context, index) {
                    final s = subscribers[index];
                    return Card(
                      color: const Color(0xFF161B22),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(s['name'] ?? ''),
                        subtitle: Text('الهاتف: ${s['phone'] ?? '-'} | الخطة: ${s['plan'] ?? '-'}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteSubscriber(s['id']),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        backgroundColor: const Color(0xFF1F6FEB),
        child: const Icon(Icons.add),
      ),
    );
  }
}