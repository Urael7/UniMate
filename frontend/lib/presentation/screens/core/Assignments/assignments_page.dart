import 'package:flutter/material.dart';
import 'package:frontend/models/assignment.dart';
import 'package:frontend/presentation/screens/core/Assignments/assignment_service.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  AssignmentsPageState createState() => AssignmentsPageState();
}

class AssignmentsPageState extends State<AssignmentsPage> {
  final AssignmentService _assignmentService = AssignmentService();
  List<Assignment> _filteredAssignments = [];

  String _statusFilter = 'all';
  String _subjectFilter = 'all';
  String _sortBy = 'dueDate';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _assignmentService.addListener(_onAssignmentsChanged);
    _searchController.addListener(_onSearchChanged);
    _applyFiltersAndSort();
  }

  @override
  void dispose() {
    _assignmentService.removeListener(_onAssignmentsChanged);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onAssignmentsChanged() {
    if (mounted) {
      _applyFiltersAndSort();
    }
  }

  void _onSearchChanged() {
    if (_searchQuery != _searchController.text) {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
          _applyFiltersAndSort();
        });
      }
    }
  }

  void _applyFiltersAndSort() {
    _assignmentService.updateOverdueStatus();
    List<Assignment> currentAssignments = _assignmentService.assignments;
    List<Assignment> filtered = List.from(currentAssignments);

    if (_statusFilter != 'all') {
      AssignmentStatus? targetStatus;
      switch (_statusFilter) {
        case 'pending':
          targetStatus = AssignmentStatus.pending;
          break;
        case 'completed':
          targetStatus = AssignmentStatus.completed;
          break;
        case 'overdue':
          targetStatus = AssignmentStatus.overdue;
          break;
      }
      if (targetStatus != null) {
        filtered = filtered.where((a) => a.status == targetStatus).toList();
      }
    }

    if (_subjectFilter != 'all') {
      filtered = filtered.where((a) => a.subject == _subjectFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered =
          filtered.where((a) {
            return a.title.toLowerCase().contains(query) ||
                a.description.toLowerCase().contains(query);
          }).toList();
    }

    filtered.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'dueDate':
          comparison = a.dueDate.compareTo(b.dueDate);
          break;
        case 'title':
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case 'subject':
          comparison = a.subject.toLowerCase().compareTo(
            b.subject.toLowerCase(),
          );
          break;
        case 'priority':
          comparison = _comparePriority(a.priority, b.priority);
          break;
        default:
          comparison = a.dueDate.compareTo(b.dueDate);
      }
      return comparison;
    });

    if (mounted) {
      setState(() {
        _filteredAssignments = filtered;
      });
    }
  }

  int _comparePriority(PriorityLevel a, PriorityLevel b) {
    const priorityOrder = {
      PriorityLevel.high: 3,
      PriorityLevel.medium: 2,
      PriorityLevel.low: 1,
    };
    return (priorityOrder[b] ?? 0).compareTo(priorityOrder[a] ?? 0);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _statusFilter = 'all';
      _subjectFilter = 'all';
      _sortBy = 'dueDate';
      _applyFiltersAndSort();
    });
  }

  bool _isAnyFilterActive() {
    return _searchQuery.isNotEmpty ||
        _statusFilter != 'all' ||
        _subjectFilter != 'all';
  }

  @override
  Widget build(BuildContext context) {
    final uniqueSubjects = ['all', ..._assignmentService.getUniqueSubjects()];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text('Assignments', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: _showAddAssignmentDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search assignments...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                        : null,
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          ExpansionPanelList(
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            expandIconColor: Colors.black,
            children: [
              ExpansionPanel(
                backgroundColor: Colors.white,
                canTapOnHeader: true,
                headerBuilder:
                    (context, isExpanded) => ListTile(
                      title: const Text(
                        'Filters & Sorting',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                body: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildFilterDropdown(
                        value: _statusFilter,
                        items: const ['all', 'pending', 'completed', 'overdue'],
                        label: 'Status',
                        onChanged: (value) {
                          setState(() => _statusFilter = value);
                          _applyFiltersAndSort();
                        },
                      ),
                      _buildFilterDropdown(
                        value: _subjectFilter,
                        items: uniqueSubjects.toList(),
                        label: 'Subject',
                        onChanged: (value) {
                          setState(() => _subjectFilter = value);
                          _applyFiltersAndSort();
                        },
                      ),
                      _buildFilterDropdown(
                        value: _sortBy,
                        items: const [
                          'dueDate',
                          'title',
                          'subject',
                          'priority',
                        ],
                        label: 'Sort By',
                        onChanged: (value) {
                          setState(() => _sortBy = value);
                          _applyFiltersAndSort();
                        },
                      ),
                      if (_isAnyFilterActive())
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TextButton(
                            onPressed: _clearFilters,
                            child: const Text('Reset Filters & Search'),
                          ),
                        ),
                    ],
                  ),
                ),
                isExpanded: _showFilters,
              ),
            ],
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _applyFiltersAndSort();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child:
                  _filteredAssignments.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _filteredAssignments.length,
                        itemBuilder: (context, index) {
                          final assignment = _filteredAssignments[index];
                          return _buildAssignmentCard(assignment);
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    bool hasOriginalAssignments = _assignmentService.assignments.isNotEmpty;
    bool filtersAreActive = _isAnyFilterActive();

    String message;
    Widget? actionButton;

    if (!hasOriginalAssignments) {
      message = 'You have no assignments yet.\nTap the "+" button to add one.';
    } else if (filtersAreActive) {
      message = 'No assignments match your search or filters.';
      actionButton = ElevatedButton(
        onPressed: _clearFilters,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Clear Filters & Search'),
      );
    } else {
      message = 'No assignments to display.';
    }

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/empty_search.json',
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.grey[300],
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              if (actionButton != null) ...[
                const SizedBox(height: 20),
                actionButton,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required String label,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items:
            items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item[0].toUpperCase() + item.substring(1),
                  style: const TextStyle(color: Colors.black87, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
        ),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }

  ({Color color, String text}) _getStatusInfo(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.pending:
        return (color: Colors.orange.shade700, text: 'Pending');
      case AssignmentStatus.completed:
        return (color: Colors.green.shade600, text: 'Completed');
      case AssignmentStatus.overdue:
        return (color: Colors.red.shade700, text: 'Overdue');
    }
  }

  Widget _buildPriorityBadge(PriorityLevel priority) {
    final info = _getPriorityInfo(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: info.backgroundColor?.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        info.text,
        style: TextStyle(
          color: info.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  ({Color textColor, Color? backgroundColor, String text}) _getPriorityInfo(
    PriorityLevel priority,
  ) {
    switch (priority) {
      case PriorityLevel.high:
        return (
          textColor: Colors.red.shade800,
          backgroundColor: Colors.redAccent,
          text: 'High',
        );
      case PriorityLevel.medium:
        return (
          textColor: Colors.orange.shade800,
          backgroundColor: Colors.orangeAccent,
          text: 'Medium',
        );
      case PriorityLevel.low:
        return (
          textColor: Colors.blue.shade800,
          backgroundColor: Colors.lightBlueAccent,
          text: 'Low',
        );
    }
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    final statusInfo = _getStatusInfo(assignment.status);
    final dueDateFormatted = DateFormat(
      'E, MMM d, yyyy', // Corrected format for clarity
    ).format(assignment.dueDate);
    final isCompleted = assignment.status == AssignmentStatus.completed;
    final bool showAsOverdue = assignment.status == AssignmentStatus.overdue;

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          print('Tapped on: ${assignment.title}');
        },
        onLongPress: () => _showDeleteConfirmationDialog(assignment),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isCompleted,
                        onChanged:
                            (value) => _assignmentService
                                .toggleAssignmentStatus(assignment.id),
                        fillColor: WidgetStateProperty.resolveWith<Color>((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.blue;
                          }
                          return Colors.grey[400]!;
                        }),
                        checkColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                            decorationColor: Colors.grey[700],
                            color:
                                isCompleted ? Colors.grey[600] : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assignment.subject,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusInfo.color.withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusInfo.text,
                      style: TextStyle(
                        color: statusInfo.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (assignment.description.isNotEmpty || !isCompleted)
                Padding(
                  padding: const EdgeInsets.only(left: 36.0, top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (assignment.description.isNotEmpty) ...[
                        Text(
                          assignment.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!isCompleted) const SizedBox(height: 12),
                      ],
                      if (!isCompleted)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPriorityBadge(assignment.priority),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color:
                                      showAsOverdue
                                          ? Colors.red.shade700
                                          : Colors.grey[600],
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Due: $dueDateFormatted',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        showAsOverdue
                                            ? Colors.red.shade700
                                            : Colors.grey[700],
                                    fontWeight:
                                        showAsOverdue
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Assignment assignment) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text('Delete Assignment?'),
            content: Text(
              'Are you sure you want to delete "${assignment.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  _assignmentService.deleteAssignment(assignment.id);
                  Navigator.pop(dialogContext);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey[600]) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }

  void _showAddAssignmentDialog() {
    final formKey = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));
    PriorityLevel priority = PriorityLevel.medium;

    if (_subjectFilter != 'all') {
      subjectController.text = _subjectFilter;
    }

    showDialog(
      context: context,
      builder:
          (dialogContext) => StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add New Assignment',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: titleController,
                            decoration: _inputDecoration('Title'),
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: subjectController,
                            decoration: _inputDecoration('Subject'),
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a subject';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: descriptionController,
                            decoration: _inputDecoration(
                              'Description (Optional)',
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 3,
                            minLines: 1,
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: dueDate,
                                firstDate: DateTime.now().subtract(
                                  const Duration(days: 30),
                                ),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365 * 2),
                                ),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: Theme.of(
                                        context,
                                      ).colorScheme.copyWith(
                                        primary: Colors.blue,
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor: Colors.white,
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (selectedDate != null) {
                                setDialogState(() => dueDate = selectedDate);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Due Date: ${DateFormat('E, MMM d, yyyy').format(dueDate)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<PriorityLevel>(
                            value: priority,
                            items:
                                PriorityLevel.values.map((level) {
                                  final info = _getPriorityInfo(level);
                                  return DropdownMenuItem<PriorityLevel>(
                                    value: level,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color:
                                                info.textColor, // Use text color for dot
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          info.text,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setDialogState(() => priority = value);
                              }
                            },
                            decoration: _inputDecoration('Priority'),
                          ),

                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    _assignmentService.addAssignment(
                                      title: titleController.text.trim(),
                                      subject: subjectController.text.trim(),
                                      dueDate: dueDate,
                                      description:
                                          descriptionController.text.trim(),
                                      priority: priority,
                                    );
                                    Navigator.pop(dialogContext);
                                  }
                                },
                                child: const Text('Add Assignment'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}