import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/event.dart';
import '../providers/admin_provider.dart';
import '../../../shared/widgets/markdown_editor.dart';
import '../../../shared/widgets/image_upload_widget.dart';
import 'dart:typed_data';

class AdminEventsPage extends ConsumerStatefulWidget {
  const AdminEventsPage({super.key});

  @override
  ConsumerState<AdminEventsPage> createState() => _AdminEventsPageState();
}

class _AdminEventsPageState extends ConsumerState<AdminEventsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsStreamProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildFilters(),
          const SizedBox(height: 24),
          Expanded(
            child: eventsAsync.when(
              data: (events) => _buildEventsGrid(events),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text('Error loading events: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(eventsStreamProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events Management',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage all events, workshops, and activities',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => _showEventDialog(),
          icon: const Icon(Icons.add),
          label: const Text('Create Event'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                onChanged: (value) => setState(() => _selectedStatus = value!),
                items: ['All', 'Upcoming', 'Ongoing', 'Completed', 'Cancelled']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsGrid(List<Event> events) {
    final filteredEvents = events.where((event) {
      final matchesSearch = _searchController.text.isEmpty ||
          event.title.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesStatus = _selectedStatus == 'All' || event.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    if (filteredEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No events found', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) => _buildEventCard(filteredEvents[index]),
    );
  }

  Widget _buildEventCard(Event event) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(event.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    event.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleEventAction(value, event),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM dd, yyyy').format(event.date),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              event.location,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              '${event.currentAttendees}/${event.maxAttendees} attendees',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming': return Colors.blue;
      case 'Ongoing': return Colors.green;
      case 'Completed': return Colors.grey;
      case 'Cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  void _handleEventAction(String action, Event event) {
    switch (action) {
      case 'edit':
        _showEventDialog(event: event);
        break;
      case 'delete':
        _deleteEvent(event);
        break;
    }
  }

  void _showEventDialog({Event? event}) {
    showDialog(
      context: context,
      builder: (context) => EventEditorDialog(event: event),
    );
  }

  void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(adminControllerProvider.notifier).deleteEvent(event.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class EventEditorDialog extends ConsumerStatefulWidget {
  final Event? event;

  const EventEditorDialog({super.key, this.event});

  @override
  ConsumerState<EventEditorDialog> createState() => _EventEditorDialogState();
}

class _EventEditorDialogState extends ConsumerState<EventEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _maxAttendeesController;

  String _description = '';
  String _category = 'Workshop';
  String _status = 'Upcoming';
  DateTime _selectedDate = DateTime.now();
  bool _isPublished = false;
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    
    _titleController = TextEditingController(text: event?.title ?? '');
    _locationController = TextEditingController(text: event?.location ?? '');
    _maxAttendeesController = TextEditingController(text: event?.maxAttendees.toString() ?? '50');

    if (event != null) {
      _description = event.description;
      _category = event.category;
      _status = event.status;
      _selectedDate = event.date;
      _isPublished = event.isPublished;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.event == null ? 'Create Event' : 'Edit Event',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Event Title *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty == true ? 'Title is required' : null,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _category,
                              onChanged: (value) => setState(() => _category = value!),
                              items: ['Workshop', 'Seminar', 'Bootcamp', 'Webinar']
                                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                                  .toList(),
                              decoration: const InputDecoration(
                                labelText: 'Category *',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _status,
                              onChanged: (value) => setState(() => _status = value!),
                              items: ['Upcoming', 'Ongoing', 'Completed']
                                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                                  .toList(),
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _locationController,
                              decoration: const InputDecoration(
                                labelText: 'Location *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value?.isEmpty == true ? 'Location is required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _maxAttendeesController,
                              decoration: const InputDecoration(
                                labelText: 'Max Attendees *',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) => value?.isEmpty == true ? 'Max attendees is required' : null,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 8),
                              Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                              const Spacer(),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      MarkdownEditor(
                        initialValue: _description,
                        onChanged: (value) => _description = value,
                        height: 200,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      CheckboxListTile(
                        title: const Text('Published'),
                        value: _isPublished,
                        onChanged: (value) => setState(() => _isPublished = value!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _saveEvent,
                    child: const Text('Save Event'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final event = Event(
        id: widget.event?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _description,
        date: _selectedDate,
        location: _locationController.text,
        category: _category,
        maxAttendees: int.parse(_maxAttendeesController.text),
        currentAttendees: widget.event?.currentAttendees ?? 0,
        status: _status,
        isPublished: _isPublished,
        createdAt: widget.event?.createdAt ?? DateTime.now(),
      );

      if (widget.event == null) {
        await ref.read(adminControllerProvider.notifier).addEvent(event);
      } else {
        await ref.read(adminControllerProvider.notifier).updateEvent(event.id, event);
      }

      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.event == null ? 'Event created!' : 'Event updated!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save event: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _maxAttendeesController.dispose();
    super.dispose();
  }
} 