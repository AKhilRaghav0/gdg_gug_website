import 'package:flutter/material.dart';
import '../../../shared/widgets/responsive_wrapper.dart';
import '../../../core/constants/app_constants.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String selectedCategory = 'all';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          _buildSearchAndFilters(context),
          _buildNewsGrid(context),
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
            Text(
              'Tech News & Insights',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Stay updated with the latest tech trends, GDG news, and developer insights from our community.',
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

  Widget _buildSearchAndFilters(BuildContext context) {
    final categories = [
      {'id': 'all', 'label': 'All Posts', 'icon': '✦'},
      {'id': 'tech-insights', 'label': 'Tech Insights', 'icon': '💡'},
      {'id': 'gdg-events', 'label': 'GDG Events', 'icon': '🎯'},
      {'id': 'success-stories', 'label': 'Success Stories', 'icon': '🌟'},
      {'id': 'developer-news', 'label': 'Developer News', 'icon': '🔥'},
    ];

    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            // Search bar
            Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search articles...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Category filters
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                final isSelected = selectedCategory == category['id'];
                return FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(category['icon'] as String),
                      const SizedBox(width: 8),
                      Text(category['label'] as String),
                    ],
                  ),
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category['id'] as String;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppConstants.googleBlue.withOpacity(0.2),
                  checkmarkColor: AppConstants.googleBlue,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsGrid(BuildContext context) {
    final articles = _getFilteredArticles();
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveWrapper(
        child: articles.isEmpty
            ? _buildEmptyState(context)
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.75,
                ),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return NewsCard(article: articles[index]);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: AppConstants.neutral400,
          ),
          const SizedBox(height: 16),
          Text(
            'No articles found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppConstants.neutral700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppConstants.neutral600,
            ),
          ),
        ],
      ),
    );
  }

  List<Article> _getFilteredArticles() {
    final allArticles = [
      Article(
        id: '1',
        title: 'Getting Started with Flutter Web Development',
        content: 'Flutter has revolutionized cross-platform development, and now with Flutter Web, you can build beautiful web applications using the same codebase...',
        image: 'assets/images/news/flutter-web.png',
        author: Author(name: 'John Doe', avatar: ''),
        category: 'tech-insights',
        tags: ['flutter', 'web', 'development'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Article(
        id: '2',
        title: 'Google I/O 2024: Key Takeaways for Developers',
        content: 'Google I/O 2024 brought exciting announcements for developers. Here are the key highlights that will shape the future of development...',
        image: 'assets/images/news/google-io.png',
        author: Author(name: 'Jane Smith', avatar: ''),
        category: 'developer-news',
        tags: ['google', 'io', 'android', 'ai'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Article(
        id: '3',
        title: 'Success Story: From Zero to Play Store',
        content: 'Meet Sarah, a computer science student who built her first Android app and published it on the Play Store within 6 months...',
        image: 'assets/images/news/success-story.png',
        author: Author(name: 'Sarah Johnson', avatar: ''),
        category: 'success-stories',
        tags: ['android', 'success', 'student'],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Article(
        id: '4',
        title: 'Firebase Workshop: Building Real-time Apps',
        content: 'Our recent Firebase workshop was a huge success! Participants learned how to build real-time applications using Firebase...',
        image: 'assets/images/news/firebase-workshop.png',
        author: Author(name: 'GDG Team', avatar: ''),
        category: 'gdg-events',
        tags: ['firebase', 'workshop', 'realtime'],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    var filtered = allArticles;
    
    // Filter by category
    if (selectedCategory != 'all') {
      filtered = filtered.where((article) => article.category == selectedCategory).toList();
    }
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((article) {
        return article.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
               article.content.toLowerCase().contains(searchQuery.toLowerCase()) ||
               article.tags.any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()));
      }).toList();
    }
    
    return filtered;
  }
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
              // Article image
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
                      // Date and category
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

class Article {
  final String id;
  final String title;
  final String content;
  final String image;
  final Author author;
  final String category;
  final List<String> tags;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.author,
    required this.category,
    required this.tags,
    required this.createdAt,
  });
}

class Author {
  final String name;
  final String avatar;

  Author({
    required this.name,
    required this.avatar,
  });
}