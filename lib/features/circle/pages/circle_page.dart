import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/responsive_wrapper.dart';
import '../models/circle_post.dart';
import '../widgets/circle_post_card.dart';
import '../widgets/circle_story_viewer.dart';
import '../widgets/create_post_widget.dart';

class CirclePage extends StatefulWidget {
  const CirclePage({super.key});

  @override
  State<CirclePage> createState() => _CirclePageState();
}

class _CirclePageState extends State<CirclePage> {
  final ScrollController _scrollController = ScrollController();
  final List<CirclePost> _posts = _generateSamplePosts();
  bool _showCreatePost = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: AppConstants.neutral50,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              pinned: true,
              title: Row(
                children: [
                  Text(
                    'Circle',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.googleBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppConstants.googleRed, AppConstants.googleYellow],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'GDG',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () => setState(() => _showCreatePost = true),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send_outlined),
                  onPressed: () {},
                ),
              ],
            ),

            // Stories Section
            SliverToBoxAdapter(
              child: Container(
                height: 120,
                color: Colors.white,
                child: const CircleStoryViewer(),
              ),
            ),

            // Create Post Section
            if (_showCreatePost)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: CreatePostWidget(
                    onCancel: () => setState(() => _showCreatePost = false),
                    onPost: (content, images) {
                      // Handle post creation
                      setState(() => _showCreatePost = false);
                    },
                  ),
                ),
              ),

            // Posts
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Posts',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => setState(() => _showCreatePost = true),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Create Post'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  final postIndex = index - 1;
                  if (postIndex >= _posts.length) return null;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CirclePostCard(
                      post: _posts[postIndex],
                      onLike: () => _handleLike(postIndex),
                      onComment: () => _handleComment(postIndex),
                      onShare: () => _handleShare(postIndex),
                    ),
                  );
                },
                childCount: _posts.length + 1,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => _showCreatePost = true),
          backgroundColor: AppConstants.googleBlue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _handleLike(int index) {
    setState(() {
      _posts[index] = _posts[index].copyWith(
        isLiked: !_posts[index].isLiked,
        likes: _posts[index].isLiked 
            ? _posts[index].likes - 1 
            : _posts[index].likes + 1,
      );
    });
  }

  void _handleComment(int index) {
    // Implement comment functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Comments'),
        content: const Text('Comment functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleShare(int index) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  static List<CirclePost> _generateSamplePosts() {
    return [
      CirclePost(
        id: '1',
        authorName: 'Rohit Sharma',
        authorAvatar: 'https://via.placeholder.com/150',
        content: 'Amazing workshop on Flutter development! 🚀 Learned so much about state management and widget composition. Can\'t wait to apply these concepts in our next project! #Flutter #GDG #Development',
        images: [],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 24,
        comments: 8,
        tags: ['Flutter', 'GDG', 'Development'],
        location: 'GUG Campus',
      ),
      CirclePost(
        id: '2',
        authorName: 'Priya Singh',
        authorAvatar: 'https://via.placeholder.com/150',
        content: 'Great networking session today! Met so many talented developers and designers. The tech community here is incredible! 💻✨',
        images: ['https://via.placeholder.com/400x300'],
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 42,
        comments: 15,
        tags: ['Networking', 'Community', 'Tech'],
        location: 'Tech Hub',
      ),
      CirclePost(
        id: '3',
        authorName: 'Arjun Patel',
        authorAvatar: 'https://via.placeholder.com/150',
        content: 'Just completed our hackathon project! 48 hours of intense coding, debugging, and lots of coffee ☕ Our team built an amazing AI-powered solution for sustainable transportation.',
        images: [
          'https://via.placeholder.com/400x300',
          'https://via.placeholder.com/400x300',
        ],
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likes: 67,
        comments: 23,
        tags: ['Hackathon', 'AI', 'Sustainability'],
        location: 'Innovation Lab',
      ),
      CirclePost(
        id: '4',
        authorName: 'Sneha Reddy',
        authorAvatar: 'https://via.placeholder.com/150',
        content: 'Excited to announce that I\'ll be speaking at the upcoming GDG DevFest! 🎤 Topic: "Building Scalable Web Applications with Modern Frameworks" See you there!',
        images: [],
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        likes: 89,
        comments: 31,
        tags: ['DevFest', 'Speaking', 'WebDev'],
      ),
      CirclePost(
        id: '5',
        authorName: 'Vikram Gupta',
        authorAvatar: 'https://via.placeholder.com/150',
        content: 'Machine Learning study group was fantastic today! We deep-dived into neural networks and practiced with TensorFlow. Love how supportive this community is! 🧠🤖',
        images: ['https://via.placeholder.com/400x300'],
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        likes: 156,
        comments: 42,
        tags: ['MachineLearning', 'TensorFlow', 'StudyGroup'],
        location: 'ML Lab',
      ),
    ];
  }
} 