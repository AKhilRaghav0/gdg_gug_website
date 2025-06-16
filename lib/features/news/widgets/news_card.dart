import 'package:flutter/material.dart';
import '../models/article.dart';
import '../../../core/constants/app_constants.dart';

class NewsCard extends StatefulWidget {
  final Article article;

  const NewsCard({super.key, required this.article});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
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
              // Article image placeholder
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      _getCategoryColor(widget.article.category).withOpacity(0.3),
                      _getCategoryColor(widget.article.category).withOpacity(0.6),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _getCategoryIcon(widget.article.category),
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(widget.article.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getCategoryLabel(widget.article.category),
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
              
              // Article details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppConstants.neutral600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(widget.article.createdAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppConstants.neutral600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Title
                      Text(
                        widget.article.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      
                      // Content preview
                      Expanded(
                        child: Text(
                          widget.article.content,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Author and tags
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppConstants.googleBlue,
                            child: Text(
                              widget.article.author.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.article.author.name,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (widget.article.tags.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppConstants.neutral200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '#${widget.article.tags.first}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                  color: AppConstants.neutral700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Read more button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle article read more
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getCategoryColor(widget.article.category),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Read More'),
                        ),
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'tech-insights':
        return Icons.lightbulb;
      case 'gdg-events':
        return Icons.event;
      case 'success-stories':
        return Icons.star;
      case 'developer-news':
        return Icons.code;
      default:
        return Icons.article;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'tech-insights':
        return AppConstants.googleBlue;
      case 'gdg-events':
        return AppConstants.googleGreen;
      case 'success-stories':
        return AppConstants.googleRed;
      case 'developer-news':
        return AppConstants.googleYellow;
      default:
        return AppConstants.neutral600;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'tech-insights':
        return 'Tech Insights';
      case 'gdg-events':
        return 'GDG Events';
      case 'success-stories':
        return 'Success Stories';
      case 'developer-news':
        return 'Developer News';
      default:
        return 'News';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}