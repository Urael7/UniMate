import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'models.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data 
  final List<Assignment> allAssignments = [
    Assignment(
      id: '1',
      title: 'Vector Spaces Problem Set',
      subject: 'Linear Algebra',
      dueDate: DateTime(2025, 5, 10),
      status: 'pending',
      progress: 0.65,
      priority: 'high',
    ),
    Assignment(
      id: '2',
      title: 'Flutter UI Challenge',
      subject: 'Mobile Development',
      dueDate: DateTime(2025, 5, 15),
      status: 'pending',
      progress: 0.30,
      priority: 'high',
    ),
    Assignment(
      id: '3',
      title: 'Historical Analysis Essay',
      subject: 'World History',
      dueDate: DateTime(2025, 5, 5),
      status: 'completed',
      progress: 1.0,
      priority: 'medium',
    ),
    Assignment(
      id: '4',
      title: 'Lab Report 5',
      subject: 'Physics II',
      dueDate: DateTime(2025, 4, 28),
      status: 'completed',
      progress: 1.0,
      priority: 'low',
    ),
    Assignment(
      id: '5',
      title: 'Calculus Quiz 3 Prep',
      subject: 'Calculus II',
      dueDate: DateTime(2025, 5, 8),
      status: 'pending',
      progress: 0.90,
      priority: 'medium',
    ),
    Assignment(
      id: '6',
      title: 'Data Structures Algo Design',
      subject: 'Data Structures',
      dueDate: DateTime(2025, 5, 22),
      status: 'pending',
      progress: 0.10,
      priority: 'high',
    ),
  ];


  List<Assignment> pendingAssignments = [];
  List<Assignment> completedAssignments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filterAssignments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _filterAssignments() {
    pendingAssignments =
        allAssignments.where((a) => a.status == 'pending').toList();
    // Sort pending by due date, soonest first
    pendingAssignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    completedAssignments =
        allAssignments.where((a) => a.status == 'completed').toList();
    // Sort completed by due date, most recent first
    completedAssignments.sort((a, b) => b.dueDate.compareTo(a.dueDate));
  }

  @override
  Widget build(BuildContext context) {
   
    final dashboardHelper = DashboardPage();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [Tab(text: 'Pending'), Tab(text: 'Completed')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Pending Tab
              if (pendingAssignments.isEmpty)
                _buildEmptyState(context, 'No pending assignments!')
              else
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: pendingAssignments.length,
                  itemBuilder: (context, index) {
                  
                    return dashboardHelper.buildAssignmentItem(
                      context,
                      pendingAssignments[index],
                    );
                  },
                ),

              // Completed Tab
              if (completedAssignments.isEmpty)
                _buildEmptyState(context, 'No completed assignments yet.')
              else
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: completedAssignments.length,
                  itemBuilder: (context, index) {
                  
                    return dashboardHelper.buildAssignmentItem(
                      context,
                      completedAssignments[index],
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
