import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/BudgetTracker/budget_service.dart';
import 'package:frontend/presentation/screens/BudgetTracker/budget_tracker_page.dart';
import 'package:frontend/presentation/screens/core/Assignments/assignment_service.dart';
import 'package:frontend/presentation/screens/core/Assignments/assignments_page.dart';
import 'package:frontend/presentation/screens/core/ClassSchedules/schedule_page.dart';
import 'package:frontend/presentation/screens/core/ClassSchedules/schedule_service.dart';
import 'package:frontend/presentation/screens/core/Dashboard/dashboard_page.dart';
import 'package:frontend/presentation/screens/core/Exams/exam_service.dart';
import 'package:frontend/presentation/screens/core/Exams/exams_page.dart';
import 'package:frontend/presentation/screens/core/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExamService()),
        ChangeNotifierProvider(create: (_) => AssignmentService()),
        ChangeNotifierProvider(create: (_) => ScheduleService()),
        ChangeNotifierProvider(create: (_) => BudgetService()),
      ],
      child: MaterialApp(
        title: 'Unimate',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Colors.white,
          scaffoldBackgroundColor: Colors.grey[50],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        home: const OnboardingScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = true;

  final double _sidebarWidthExpanded = 240;
  final double _sidebarWidthCollapsed = 65;

  final List<Widget> _pages = [
    const DashboardPage(),
    const SchedulePage(),
    const AssignmentsPage(),
    const ExamsPage(),
    const NotificationsPage(),
    const ProfilePage(),
    const ResourcesPage(),
  ];

  final List<SidebarItem> _sidebarItems = [
    SidebarItem(title: 'Dashboard', icon: LucideIcons.layoutDashboard),
    SidebarItem(title: 'Class Schedule', icon: LucideIcons.calendar),
    SidebarItem(title: 'Assignments', icon: LucideIcons.clipboardList),
    SidebarItem(title: 'Exams', icon: LucideIcons.fileText),
    SidebarItem(title: 'Notifications', icon: LucideIcons.bell),
    SidebarItem(title: 'Profile', icon: LucideIcons.user),
    SidebarItem(title: 'Resources', icon: LucideIcons.bookOpen),
    SidebarItem(title: 'Logout', icon: LucideIcons.logOut),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Widget
          Material(
            elevation: 4.0,
            child: Container(
              width:
                  _isSidebarCollapsed
                      ? _sidebarWidthCollapsed
                      : _sidebarWidthExpanded,
              color: Colors.white,
              child: Column(
                children: [
                  // Sidebar Header
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: _isSidebarCollapsed ? 8 : 16,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            _isSidebarCollapsed
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.spaceBetween,
                        children: [
                          if (!_isSidebarCollapsed)
                            const Expanded(
                              child: Text(
                                'UNIMATE',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          IconButton(
                            icon: Icon(
                              _isSidebarCollapsed
                                  ? LucideIcons.chevronRight
                                  : LucideIcons.chevronLeft,
                              size: 20,
                            ),
                            tooltip:
                                _isSidebarCollapsed
                                    ? 'Expand Sidebar'
                                    : 'Collapse Sidebar',
                            onPressed: () {
                              setState(() {
                                _isSidebarCollapsed = !_isSidebarCollapsed;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  // Sidebar Items List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _sidebarItems.length,
                      itemBuilder: (context, index) {
                        final item = _sidebarItems[index];
                        return _buildSidebarItem(
                          item,
                          index,
                          _isSidebarCollapsed,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            child:
                _selectedIndex < _pages.length
                    ? _pages[_selectedIndex]
                    : Container(
                      // Fallback for invalid index
                      alignment: Alignment.center,
                      child: const Text('Page not found'),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(SidebarItem item, int index, bool isCollapsed) {
    final isSelected = _selectedIndex == index;
    final isLogout = item.title == 'Logout';

    Widget itemContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment:
            isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(
            item.icon,
            size: 22,
            color:
                isSelected
                    ? Colors.blue
                    : isLogout
                    ? Colors.red.shade600
                    : Colors.grey[700],
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isSelected
                          ? Colors.blue
                          : isLogout
                          ? Colors.red.shade600
                          : Colors.grey[800],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 4 : 8,
        vertical: 2,
      ),
      child: Tooltip(
        message: isCollapsed ? item.title : '',
        preferBelow: false,
        verticalOffset: isCollapsed ? 20 : 0,
        waitDuration: isCollapsed ? Duration(milliseconds: 300) : Duration.zero,
        child: InkWell(
          onTap: () {
            if (isLogout) {
              _showLogoutConfirmation();
            } else if (_selectedIndex != index) {
              setState(() {
                _selectedIndex = index;
                if (!_isSidebarCollapsed) {
                  _isSidebarCollapsed = true;
                }
              });
            }
          },
          borderRadius: BorderRadius.circular(8),
          splashColor:
              isSelected
                  ? Colors.blue.withAlpha((0.1 * 255).toInt())
                  : Colors.grey.withAlpha((0.1 * 255).toInt()),
          highlightColor:
              isSelected
                  ? Colors.blue.withAlpha((0.05 * 255).toInt())
                  : Colors.grey.withAlpha((0.05 * 255).toInt()),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[50] : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: itemContent,
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog

                  // logout logic here

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => OnboardingScreen()),
                    (Route<dynamic> route) =>
                        false, // Remove all previous routes
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Notifications Page'));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Profile Page'));
}

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Resources Page'));
}

class SidebarItem {
  final String title;
  final IconData icon;

  SidebarItem({required this.title, required this.icon});
}
