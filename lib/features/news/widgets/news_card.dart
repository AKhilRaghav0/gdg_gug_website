import 'package:flutter/material.dart';
import '../models/article.dart';
import '../../../core/constants/app_constants.dart';

class NewsCard extends StatelessWidget {
  final Article article;

  const NewsCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: AppConstants.neutral100,
            ),
            child: article.image != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      article.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    ),
                  )
                : _buildPlaceholderImage(),
          ),
          
          // Article content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(article.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      article.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getCategoryColor(article.category),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Article title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Article excerpt
                  Expanded(
                    child: Text(
                      article.excerpt,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.neutral600,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Article metadata
                  Row(
                    children: [
                      // Author avatar
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppConstants.googleBlue.withOpacity(0.1),
                        child: article.author.avatar != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  article.author.avatar!,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      size: 16,
                                      color: AppConstants.googleBlue,
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 16,
                                color: AppConstants.googleBlue,
                              ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Author name and date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.author.name,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _formatDate(article.createdAt),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppConstants.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Read time
                      Text(
                        article.readTime,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.neutral500,
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
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: AppConstants.neutral100,
      ),
      child: Center(
        child: Icon(
          Icons.article,
          size: 48,
          color: AppConstants.neutral400,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'tech-insights':
        return AppConstants.googleBlue;
      case 'gdg-events':
        return AppConstants.googleGreen;
      case 'success-stories':
        return AppConstants.googleYellow;
      case 'developer-news':
        return AppConstants.googleRed;
      default:
        return AppConstants.googleBlue;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
} 