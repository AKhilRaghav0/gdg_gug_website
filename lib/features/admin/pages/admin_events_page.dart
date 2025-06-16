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
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsStreamProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      backgroundColor: AppConstants.neutral50,
      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(isDesktop ? 32 : 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppConstants.neutral200)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.event, size: isDesktop ? 32 : 24, color: AppConstants.googleBlue),
                    SizedBox(width: isDesktop ? 16 : 8),
                    Text(
                      'Event Management',
                      style: TextStyle(
                        fontSize: isDesktop ? 28 : 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.neutral900,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showEventDialog(context),
                      icon: const Icon(Icons.add),
                      label: Text(isDesktop ? 'Create Event' : 'Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.googleBlue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 24 : 16,
                          vertical: isDesktop ? 16 : 12,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isDesktop) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search events...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppConstants.neutral300),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: ['All', 'Published', 'Draft', 'Upcoming', 'Past']
                              .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                              .toList(),
                          onChanged: (value) => setState(() => _selectedStatus = value!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: ['All', 'Workshop', 'Seminar', 'Bootcamp', 'Meetup', 'Conference']
                              .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                              .toList(),
                          onChanged: (value) => setState(() => _selectedCategory = value!),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Events List
          Expanded(
            child: eventsAsync.when(
              data: (events) {
                final filteredEvents = _filterEvents(events);
                
                if (filteredEvents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: AppConstants.neutral400),
                        const SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppConstants.neutral600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first event to get started',
                          style: TextStyle(color: AppConstants.neutral500),
                        ),
                      ],
                    ),
                  );
                }

                return isDesktop ? _buildDesktopEventsList(filteredEvents) : _buildMobileEventsList(filteredEvents);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppConstants.googleRed),
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

  List<Event> _filterEvents(List<Event> events) {
    return events.where((event) {
      final matchesSearch = _searchController.text.isEmpty ||
          event.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          event.description.toLowerCase().contains(_searchController.text.toLowerCase());
      
      final matchesStatus = _selectedStatus == 'All' ||
          (_selectedStatus == 'Published' && event.isPublished) ||
          (_selectedStatus == 'Draft' && !event.isPublished) ||
          (_selectedStatus == 'Upcoming' && event.isUpcoming) ||
          (_selectedStatus == 'Past' && event.isPast);
      
      final matchesCategory = _selectedCategory == 'All' || event.category == _selectedCategory;
      
      return matchesSearch && matchesStatus && matchesCategory;
    }).toList();
  }

  Widget _buildDesktopEventsList(List<Event> events) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.8,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) => _buildEventCard(events[index], isDesktop: true),
      ),
    );
  }

  Widget _buildMobileEventsList(List<Event> events) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildEventCard(events[index], isDesktop: false),
      ),
    );
  }

  Widget _buildEventCard(Event event, {required bool isDesktop}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          Container(
            height: isDesktop ? 160 : 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(event.category).withOpacity(0.3),
                  _getCategoryColor(event.category).withOpacity(0.6),
                ],
              ),
            ),
            child: Stack(
              children: [
                if (event.imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      event.imageUrl!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildDefaultEventImage(event),
                    ),
                  )
                else
                  _buildDefaultEventImage(event),
                
                // Status Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: event.isPublished ? AppConstants.googleGreen : AppConstants.googleYellow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.isPublished ? 'Published' : 'Draft',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Event Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: isDesktop ? 16 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: isDesktop ? 14 : 12,
                      color: AppConstants.neutral600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: AppConstants.neutral500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDate(event.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.neutral600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: AppConstants.neutral500),
                      const SizedBox(width: 4),
                      Text(
                        '${event.currentAttendees}/${event.maxAttendees}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.neutral600,
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
                        child: Icon(Icons.more_vert, color: AppConstants.neutral500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultEventImage(Event event) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCategoryColor(event.category).withOpacity(0.3),
            _getCategoryColor(event.category).withOpacity(0.6),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Center(
        child: Icon(
          _getCategoryIcon(event.category),
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'workshop':
        return AppConstants.googleBlue;
      case 'seminar':
        return AppConstants.googleGreen;
      case 'bootcamp':
        return AppConstants.googleRed;
      case 'meetup':
        return AppConstants.googleYellow;
      case 'conference':
        return Colors.purple;
      default:
        return AppConstants.neutral500;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'workshop':
        return Icons.build;
      case 'seminar':
        return Icons.school;
      case 'bootcamp':
        return Icons.fitness_center;
      case 'meetup':
        return Icons.people;
      case 'conference':
        return Icons.business;
      default:
        return Icons.event;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleEventAction(String action, Event event) {
    switch (action) {
      case 'edit':
        _showEventDialog(context, event: event);
        break;
      case 'duplicate':
        _showEventDialog(context, event: event, isDuplicate: true);
        break;
      case 'delete':
        _showDeleteDialog(event);
        break;
    }
  }

  void _showDeleteDialog(Event event) {
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

  void _showEventDialog(BuildContext context, {Event? event, bool isDuplicate = false}) {
    showDialog(
      context: context,
      builder: (context) => EventEditorDialog(
        event: event,
        isDuplicate: isDuplicate,
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
  final _durationController = TextEditingController();
  final _registrationUrlController = TextEditingController();
  final _organizerController = TextEditingController();
  final _feeController = TextEditingController();
  final _meetingLinkController = TextEditingController();

  String _description = '';
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Workshop';
  String? _imageUrl;
  bool _isPublished = false;
  bool _isOnline = false;
  bool _isSaving = false;

  final List<String> _categories = ['Workshop', 'Seminar', 'Bootcamp', 'Meetup', 'Conference'];

  @override
  void initState() {
    super.initState();
    if (widget.event != null && !widget.isDuplicate) {
      _populateFields(widget.event!);
    } else if (widget.event != null && widget.isDuplicate) {
      _populateFields(widget.event!, isDuplicate: true);
    }
  }

  void _populateFields(Event event, {bool isDuplicate = false}) {
    _titleController.text = isDuplicate ? '${event.title} (Copy)' : event.title;
    _description = event.description;
    _selectedDate = event.date;
    _locationController.text = event.location;
    _imageUrl = event.imageUrl;
    _selectedCategory = event.category;
    _maxAttendeesController.text = event.maxAttendees.toString();
    _durationController.text = event.duration;
    _registrationUrlController.text = event.registrationUrl ?? '';
    _isPublished = isDuplicate ? false : event.isPublished;
    _organizerController.text = event.organizer ?? '';
    _feeController.text = event.fee?.toString() ?? '';
    _isOnline = event.isOnline;
    _meetingLinkController.text = event.meetingLink ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Dialog(
      child: Container(
        width: isDesktop ? 800 : double.infinity,
        height: isDesktop ? 700 : double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
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

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Image Upload
                      ImageUploadWidget(
                        initialImageUrl: _imageUrl,
                        onImageSelected: (bytes) {
                          // Handle image selection
                        },
                        onImageUploaded: (url) => setState(() => _imageUrl = url),
                        folder: 'events',
                        width: double.infinity,
                        height: 200,
                      ),
                      const SizedBox(height: 24),

                      // Basic Info
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(labelText: 'Event Title'),
                              validator: (value) => value?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              onChanged: (value) => setState(() => _selectedCategory = value!),
                              items: _categories
                                  .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                                  .toList(),
                              decoration: const InputDecoration(labelText: 'Category'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      MarkdownEditor(
                        initialValue: _description,
                        onChanged: (text) => _description = text,
                        height: 200,
                      ),
                      const SizedBox(height: 16),

                      // Date and Location
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
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
                              child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'Event Date'),
                                child: Text(_formatDate(_selectedDate)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _locationController,
                              decoration: const InputDecoration(labelText: 'Location'),
                              validator: (value) => value?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Capacity and Duration
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _maxAttendeesController,
                              decoration: const InputDecoration(labelText: 'Max Attendees'),
                              keyboardType: TextInputType.number,
                              validator: (value) => value?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _durationController,
                              decoration: const InputDecoration(labelText: 'Duration'),
                              validator: (value) => value?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Optional Fields
                      TextFormField(
                        controller: _registrationUrlController,
                        decoration: const InputDecoration(labelText: 'Registration URL (Optional)'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _organizerController,
                        decoration: const InputDecoration(labelText: 'Organizer (Optional)'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _feeController,
                        decoration: const InputDecoration(labelText: 'Fee (Optional)'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Online Event Toggle
                      SwitchListTile(
                        title: const Text('Online Event'),
                        value: _isOnline,
                        onChanged: (value) => setState(() => _isOnline = value),
                      ),
                      if (_isOnline) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _meetingLinkController,
                          decoration: const InputDecoration(labelText: 'Meeting Link'),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Publish Toggle
                      SwitchListTile(
                        title: const Text('Publish Event'),
                        value: _isPublished,
                        onChanged: (value) => setState(() => _isPublished = value),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.googleBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Save Event'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate() || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      final event = Event(
        id: widget.event?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _description,
        date: _selectedDate,
        location: _locationController.text,
        imageUrl: _imageUrl,
        category: _selectedCategory,
        maxAttendees: int.parse(_maxAttendeesController.text),
        currentAttendees: widget.event?.currentAttendees ?? 0,
        duration: _durationController.text,
        registrationUrl: _registrationUrlController.text.isEmpty ? null : _registrationUrlController.text,
        isPublished: _isPublished,
        organizer: _organizerController.text.isEmpty ? null : _organizerController.text,
        fee: _feeController.text.isEmpty ? null : double.tryParse(_feeController.text),
        isOnline: _isOnline,
        meetingLink: _meetingLinkController.text.isEmpty ? null : _meetingLinkController.text,
      );

      if (widget.event == null || widget.isDuplicate) {
        await ref.read(adminControllerProvider.notifier).addEvent(event);
      } else {
        await ref.read(adminControllerProvider.notifier).updateEvent(event.id, event);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event ${widget.event == null || widget.isDuplicate ? 'created' : 'updated'} successfully!'),
            backgroundColor: AppConstants.googleGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving event: $e'),
            backgroundColor: AppConstants.googleRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _maxAttendeesController.dispose();
    _durationController.dispose();
    _registrationUrlController.dispose();
    _organizerController.dispose();
    _feeController.dispose();
    _meetingLinkController.dispose();
    super.dispose();
  }
} 