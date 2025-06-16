import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

// Article model for news cards
class Article {
  final String id;
  final String title;
  final String content;
  final String? image;
  final Author author;
  final String category;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isPublished;
  final int viewCount;
  final int likeCount;

  Article({
    required this.id,
    required this.title,
    required this.content,
    this.image,
    required this.author,
    required this.category,
    required this.tags,
    required this.createdAt,
    this.updatedAt,
    required this.isPublished,
    this.viewCount = 0,
    this.likeCount = 0,
  });

  String get excerpt {
    if (content.length <= 150) return content;
    return '${content.substring(0, 150)}...';
  }

  String get readTime {
    final words = content.split(' ').length;
    final minutes = (words / 200).ceil();
    return '$minutes min read';
  }
}

class Author {
  final String name;
  final String? avatar;
  final String? bio;
  final String? email;

  Author({
    required this.name,
    this.avatar,
    this.bio,
    this.email,
  });
}

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
                          widget.article.excerpt,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.article.author.name,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (widget.article.tags.isNotEmpty)
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '#${widget.article.tags.first}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(widget.article.category),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.article.readTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return Icons.code;
      case 'design':
        return Icons.design_services;
      case 'business':
        return Icons.business;
      case 'tutorial':
        return Icons.school;
      default:
        return Icons.article;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return AppConstants.googleBlue;
      case 'design':
        return AppConstants.googleGreen;
      case 'business':
        return AppConstants.googleRed;
      case 'tutorial':
        return AppConstants.googleYellow;
      default:
        return AppConstants.neutral500;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return 'Technology';
      case 'design':
        return 'Design';
      case 'business':
        return 'Business';
      case 'tutorial':
        return 'Tutorial';
      default:
        return category;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}