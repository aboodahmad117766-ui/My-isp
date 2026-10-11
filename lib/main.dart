import 'package:flutter/material.dart';

void main() {
  runApp(const MyIspApp());
}

class MyIspApp extends StatelessWidget {
  const MyIspApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MYISP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1F6FEB),
          surface: Color(0xFF161B22),
          error: Color(0xFFCF222E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// ==================== الشاشة الرئيسية ====================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // قائمة الصفحات
  final List<Widget> _pages = [
    const DashboardPage(),
    const Center(child: Text('صفحة المشتركين - قيد الإنشاء', style: TextStyle(color: Colors.white))),
    const Center(child: Text('صفحة الأجهزة - قيد الإنشاء', style: TextStyle(color: Colors.white))),
    const Center(child: Text('صفحة الحسابات - قيد الإنشاء', style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MYISP - إدارة الشبكة', style: TextStyle(color: Colors.white)),
      ),
      // القائمة الجانبية
      drawer: Drawer(
        backgroundColor: const Color(0xFF161B22),
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
                  SizedBox(height: 8),
                  Text('إدارة شبكة الإنترنت', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'لوحة التحكم', 0),
            _buildDrawerItem(Icons.people, 'المشتركون', 1),
            _buildDrawerItem(Icons.router, 'الأجهزة', 2),
            _buildDrawerItem(Icons.calendar_month, 'الاشتراكات', 3),
            _buildDrawerItem(Icons.money, 'الحسابات والأرباح', 4),
            _buildDrawerItem(Icons.notifications, 'التنبيهات', 5),
            _buildDrawerItem(Icons.group_work, 'المجموعات', 6),
            _buildDrawerItem(Icons.badge, 'الموظفون', 7),
            _buildDrawerItem(Icons.network_ping, 'فحص الاتصال Ping', 8),
            _buildDrawerItem(Icons.history, 'سجل العمليات', 9),
            const Divider(color: Colors.grey),
            _buildDrawerItem(Icons.settings, 'الإعدادات', 10),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      // شريط التنقل السفلي
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF1F6FEB),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF161B22),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'المشتركون'),
          BottomNavigationBarItem(icon: Icon(Icons.router), label: 'الأجهزة'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'الحسابات'),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء عناصر القائمة الجانبية
  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[400]),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context); // إغلاق القائمة
        // إذا كانت الصفحة موجودة في القائمة السفلية ننتقل إليها
        if (index < 4) {
          setState(() {
            _selectedIndex = index;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('صفحة $title قيد الإنشاء حالياً')),
          );
        }
      },
    );
  }
}

// ==================== لوحة التحكم (Dashboard) ====================
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('نظرة عامة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          // شبكة الإحصائيات
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: const [
              StatCard(title: 'إجمالي المشتركين', value: '0', icon: Icons.people, color: Colors.blue),
              StatCard(title: 'المشتركون النشطون', value: '0', icon: Icons.check_circle, color: Colors.green),
              StatCard(title: 'الاشتراكات المنتهية', value: '0', icon: Icons.cancel, color: Colors.red),
              StatCard(title: 'دخل اليوم', value: '0', icon: Icons.attach_money, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 24),
          const Text('آخر الدفعات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF30363D)),
            ),
            child: const Center(
              child: Text('لا يوجد دفعات مسجلة حالياً', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== كرت الإحصائيات ====================
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}