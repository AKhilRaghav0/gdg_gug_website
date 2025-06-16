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
import '../../../core/constants/app_constants.dart';

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
            backgroundColor: AppConstants.googleBlue,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (action) => _handleEventAction(action, event),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
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
              event.location,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${event.currentAttendees}/${event.maxAttendees}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppConstants.googleBlue;
      case 'ongoing':
        return AppConstants.googleGreen;
      case 'completed':
        return AppConstants.neutral500;
      case 'cancelled':
        return AppConstants.googleRed;
      default:
        return AppConstants.neutral400;
    }
  }

  void _handleEventAction(String action, Event event) {
    switch (action) {
      case 'edit':
        _showEventDialog(event: event);
        break;
      case 'duplicate':
        _showEventDialog(event: event, isDuplicate: true);
        break;
      case 'delete':
        _deleteEvent(event);
        break;
    }
  }

  void _showEventDialog({Event? event, bool isDuplicate = false}) {
    showDialog(
      context: context,
      builder: (context) => EventEditorDialog(event: event, isDuplicate: isDuplicate),
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
          TextButton(
            onPressed: () async {
              await ref.read(adminControllerProvider.notifier).deleteEvent(event.id);
              if (mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppConstants.googleRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class EventEditorDialog extends ConsumerStatefulWidget {
  final Event? event;
  final bool isDuplicate;

  const EventEditorDialog({super.key, this.event, this.isDuplicate = false});

  @override
  ConsumerState<EventEditorDialog> createState() => _EventEditorDialogState();
}

class _EventEditorDialogState extends ConsumerState<EventEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxAttendeesController = TextEditingController();

  String _description = '';
  String _category = 'Workshop';
  String _status = 'Upcoming';
  DateTime _selectedDate = DateTime.now();
  bool _isPublished = true;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.event != null && !widget.isDuplicate) {
      _titleController.text = widget.event!.title;
      _locationController.text = widget.event!.location;
      _maxAttendeesController.text = widget.event!.maxAttendees.toString();
      _description = widget.event!.description;
      _category = widget.event!.category;
      _status = widget.event!.status;
      _selectedDate = widget.event!.date;
      _isPublished = widget.event!.isPublished;
      _imageUrl = widget.event!.imageUrl;
    } else if (widget.event != null && widget.isDuplicate) {
      _titleController.text = '${widget.event!.title} (Copy)';
      _locationController.text = widget.event!.location;
      _maxAttendeesController.text = widget.event!.maxAttendees.toString();
      _description = widget.event!.description;
      _category = widget.event!.category;
      _imageUrl = widget.event!.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.event == null || widget.isDuplicate ? 'Create Event' : 'Edit Event',
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
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info Section
                      _buildSection('Basic Information', [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Event Title'),
                          validator: (value) => value?.isEmpty == true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _category,
                                onChanged: (value) => setState(() => _category = value!),
                                items: ['Workshop', 'Seminar', 'Bootcamp', 'Conference', 'Meetup']
                                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                                    .toList(),
                                decoration: const InputDecoration(labelText: 'Category'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _status,
                                onChanged: (value) => setState(() => _status = value!),
                                items: ['Upcoming', 'Ongoing', 'Completed', 'Cancelled']
                                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                                    .toList(),
                                decoration: const InputDecoration(labelText: 'Status'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(labelText: 'Location'),
                          validator: (value) => value?.isEmpty == true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _maxAttendeesController,
                          decoration: const InputDecoration(labelText: 'Max Attendees'),
                          keyboardType: TextInputType.number,
                          validator: (value) => value?.isEmpty == true ? 'Required' : null,
                        ),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                                             // Description Section
                       _buildSection('Description', [
                         MarkdownEditor(
                           initialValue: _description,
                           onChanged: (text) => _description = text,
                           height: 200,
                         ),
                       ]),
                       
                       const SizedBox(height: 24),
                       
                       // Image Section
                       _buildSection('Event Image', [
                         ImageUploadWidget(
                           initialImageUrl: _imageUrl,
                           onImageSelected: (bytes) {
                             // Handle image selection
                           },
                           onImageUploaded: (url) => setState(() => _imageUrl = url),
                           folder: 'events',
                         ),
                       ]),
                      
                      const SizedBox(height: 24),
                      
                      // Settings Section
                      _buildSection('Settings', [
                        SwitchListTile(
                          title: const Text('Published'),
                          subtitle: const Text('Event is visible to users'),
                          value: _isPublished,
                          onChanged: (value) => setState(() => _isPublished = value),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.googleBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    final event = Event(
      id: widget.event != null && !widget.isDuplicate ? widget.event!.id : '',
      title: _titleController.text,
      description: _description,
      date: _selectedDate,
      location: _locationController.text,
      imageUrl: _imageUrl,
      category: _category,
      maxAttendees: int.parse(_maxAttendeesController.text),
      currentAttendees: widget.event?.currentAttendees ?? 0,
      status: _status,
      isPublished: _isPublished,
    );

    try {
      if (widget.event == null || widget.isDuplicate) {
        await ref.read(adminControllerProvider.notifier).addEvent(event);
      } else {
        await ref.read(adminControllerProvider.notifier).updateEvent(event.id, event);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event: $e')),
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