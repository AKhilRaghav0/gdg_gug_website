import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../shared/widgets/responsive_wrapper.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/event.dart';
import '../../admin/providers/admin_provider.dart';

class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(publishedEventsStreamProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          eventsAsync.when(
            data: (events) => _buildEventsContent(context, events),
            loading: () => _buildLoadingState(),
            error: (error, stack) => _buildErrorState(context, error.toString()),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Our ',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.neutral900,
                    ),
                  ),
                  TextSpan(
                    text: 'Events',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.googleBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Join us for exciting tech events, workshops, and community gatherings',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsContent(BuildContext context, List<Event> events) {
    if (events.isEmpty) {
      return _buildEmptyState(context);
    }

    // Separate upcoming and past events
    final now = DateTime.now();
    final upcomingEvents = events.where((event) => event.date.isAfter(now)).toList();
    final pastEvents = events.where((event) => event.date.isBefore(now)).toList();

    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (upcomingEvents.isNotEmpty) ...[
              _buildSectionTitle(context, 'Upcoming Events', AppConstants.googleBlue),
              const SizedBox(height: 32),
              _buildEventsGrid(context, upcomingEvents),
              const SizedBox(height: 64),
            ],
            if (pastEvents.isNotEmpty) ...[
              _buildSectionTitle(context, 'Past Events', AppConstants.neutral600),
              const SizedBox(height: 32),
              _buildEventsGrid(context, pastEvents),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, Color color) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildEventsGrid(BuildContext context, List<Event> events) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 768) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1024) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.75,
          ),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return EventCard(event: events[index]);
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppConstants.googleBlue),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.googleRed,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading events',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppConstants.googleRed,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.neutral600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: AppConstants.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              'No events found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppConstants.neutral600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back soon for upcoming events!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isUpcoming = widget.event.date.isAfter(DateTime.now());
    
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, isHovered ? -8.0 : 0.0),
        child: Card(
          elevation: isHovered ? 12 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getCategoryColor(widget.event.category).withOpacity(0.8),
                        _getCategoryColor(widget.event.category).withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: widget.event.imageUrl != null && widget.event.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.event.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                        )
                      : _buildPlaceholderImage(),
                ),
              ),
              
              // Event content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category and status
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(widget.event.category).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.event.category.toUpperCase(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getCategoryColor(widget.event.category),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isUpcoming 
                                  ? AppConstants.googleGreen.withOpacity(0.1)
                                  : AppConstants.neutral400.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isUpcoming ? 'UPCOMING' : 'PAST',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isUpcoming ? AppConstants.googleGreen : AppConstants.neutral400,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Event title
                      Text(
                        widget.event.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Event date
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppConstants.neutral600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMM dd, yyyy • HH:mm').format(widget.event.date),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppConstants.neutral600,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Event description
                      Expanded(
                        child: Text(
                          widget.event.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Event details
                      Row(
                        children: [
                          if (widget.event.isOnline)
                            Icon(
                              Icons.videocam,
                              size: 16,
                              color: AppConstants.googleBlue,
                            ),
                          if (!widget.event.isOnline)
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppConstants.googleRed,
                            ),
                          const SizedBox(width: 4),
                          Text(
                            widget.event.isOnline ? 'Online Event' : widget.event.location ?? 'TBA',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: widget.event.isOnline ? AppConstants.googleBlue : AppConstants.googleRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCategoryColor(widget.event.category).withOpacity(0.8),
            _getCategoryColor(widget.event.category).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.event,
        size: 48,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'workshop':
        return AppConstants.googleBlue;
      case 'meetup':
        return AppConstants.googleGreen;
      case 'conference':
        return AppConstants.googleRed;
      case 'hackathon':
        return AppConstants.googleYellow;
      case 'webinar':
        return const Color(0xFF9C27B0); // Purple
      default:
        return AppConstants.googleBlue;
    }
  }
} 