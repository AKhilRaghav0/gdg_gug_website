import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/circle_post.dart';

class CirclePostCard extends StatefulWidget {
  final CirclePost post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const CirclePostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  State<CirclePostCard> createState() => _CirclePostCardState();
}

class _CirclePostCardState extends State<CirclePostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;
  bool _showHeartAnimation = false;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _likeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _likeAnimationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.neutral900.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          
          // Content
          if (widget.post.content.isNotEmpty) _buildContent(),
          
          // Images
          if (widget.post.images.isNotEmpty) _buildImages(),
          
          // Actions
          _buildActions(),
          
          // Likes and Comments count
          _buildStats(),
          
          // Timestamp
          _buildTimestamp(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppConstants.googleBlue, AppConstants.googleRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: widget.post.authorAvatar.startsWith('http')
                    ? Image.network(
                        widget.post.authorAvatar,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildAvatarFallback();
                        },
                      )
                    : _buildAvatarFallback(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Author info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.post.authorName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.post.location != null) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppConstants.neutral500,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        widget.post.location!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.neutral500,
                        ),
                      ),
                    ],
                  ],
                ),
                if (widget.post.tags.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: widget.post.tags.take(3).map((tag) {
                      return Text(
                        '#$tag',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.googleBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          
          // More button
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppConstants.googleBlue.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        color: AppConstants.googleBlue,
        size: 20,
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.post.content,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildImages() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: widget.post.images.length == 1
          ? _buildSingleImage()
          : _buildMultipleImages(),
    );
  }

  Widget _buildSingleImage() {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.post.images.first,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppConstants.neutral200,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: AppConstants.neutral500,
                    ),
                  );
                },
              ),
            ),
          ),
          if (_showHeartAnimation)
            Center(
              child: AnimatedBuilder(
                animation: _likeAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _likeAnimation.value,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 80,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMultipleImages() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: widget.post.images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onDoubleTap: _handleDoubleTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.post.images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppConstants.neutral200,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: AppConstants.neutral500,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Like button
          GestureDetector(
            onTap: widget.onLike,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: widget.post.isLiked ? Colors.red : AppConstants.neutral600,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          
          // Comment button
          GestureDetector(
            onTap: widget.onComment,
            child: const Icon(
              Icons.chat_bubble_outline,
              color: AppConstants.neutral600,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          
          // Share button
          GestureDetector(
            onTap: widget.onShare,
            child: const Icon(
              Icons.send_outlined,
              color: AppConstants.neutral600,
              size: 24,
            ),
          ),
          
          const Spacer(),
          
          // Bookmark button
          const Icon(
            Icons.bookmark_border,
            color: AppConstants.neutral600,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.likes > 0)
            Text(
              '${widget.post.likes} likes',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          if (widget.post.comments > 0)
            GestureDetector(
              onTap: widget.onComment,
              child: Text(
                'View all ${widget.post.comments} comments',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.neutral500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimestamp() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        _formatTimestamp(widget.post.timestamp),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppConstants.neutral500,
        ),
      ),
    );
  }

  void _handleDoubleTap() {
    if (!widget.post.isLiked) {
      widget.onLike();
      setState(() => _showHeartAnimation = true);
      _likeAnimationController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() => _showHeartAnimation = false);
            _likeAnimationController.reset();
          }
        });
      });
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
} 