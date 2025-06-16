import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class CircleStoryViewer extends StatelessWidget {
  const CircleStoryViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _stories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStoryItem(context);
          }
          return _buildStoryItem(context, _stories[index - 1]);
        },
      ),
    );
  }

  Widget _buildAddStoryItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppConstants.neutral300, width: 2),
            ),
            child: const Icon(
              Icons.person,
              color: AppConstants.neutral500,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your story',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, StoryData story) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: story.isViewed 
                  ? null 
                  : LinearGradient(
                      colors: [
                        AppConstants.googleRed,
                        AppConstants.googleYellow,
                        AppConstants.googleBlue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              border: story.isViewed 
                  ? Border.all(color: AppConstants.neutral300, width: 2)
                  : null,
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.person,
                color: AppConstants.googleBlue,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 60,
            child: Text(
              story.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: story.isViewed ? AppConstants.neutral500 : AppConstants.neutral900,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static final List<StoryData> _stories = [
    StoryData(id: '1', name: 'Rohit', avatar: '', isViewed: false),
    StoryData(id: '2', name: 'Priya', avatar: '', isViewed: true),
    StoryData(id: '3', name: 'Arjun', avatar: '', isViewed: false),
    StoryData(id: '4', name: 'Sneha', avatar: '', isViewed: false),
    StoryData(id: '5', name: 'Vikram', avatar: '', isViewed: true),
  ];
}

class StoryData {
  final String id;
  final String name;
  final String avatar;
  final bool isViewed;

  StoryData({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isViewed,
  });
} 