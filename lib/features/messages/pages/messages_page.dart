import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/responsive_wrapper.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final List<MessageThread> _conversations = _generateSampleConversations();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: AppConstants.neutral50,
        body: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              pinned: true,
              title: Row(
                children: [
                  Text(
                    'Messages',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.googleBlue,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Messages List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Recent Chats',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  
                  final conversationIndex = index - 1;
                  if (conversationIndex >= _conversations.length) return null;
                  
                  return _buildMessageThread(_conversations[conversationIndex]);
                },
                childCount: _conversations.length + 1,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Start new conversation
          },
          backgroundColor: AppConstants.googleBlue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMessageThread(MessageThread thread) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppConstants.neutral900.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
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
                child: Center(
                  child: Text(
                    thread.name[0].toUpperCase(),
                    style: TextStyle(
                      color: AppConstants.googleBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            if (thread.isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                thread.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              _formatTime(thread.lastMessageTime),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.neutral500,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            if (thread.lastMessageFromMe)
              Icon(
                Icons.check,
                size: 16,
                color: thread.isRead ? AppConstants.googleBlue : AppConstants.neutral400,
              ),
            Expanded(
              child: Text(
                thread.lastMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: thread.hasUnread ? AppConstants.neutral900 : AppConstants.neutral600,
                  fontWeight: thread.hasUnread ? FontWeight.w500 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (thread.hasUnread)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppConstants.googleBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  thread.unreadCount.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          // Navigate to chat detail
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening chat with ${thread.name}')),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  static List<MessageThread> _generateSampleConversations() {
    return [
      MessageThread(
        id: '1',
        name: 'Rohit Sharma',
        lastMessage: 'Hey! Are you joining the Flutter workshop tomorrow?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        hasUnread: true,
        unreadCount: 2,
        isOnline: true,
        lastMessageFromMe: false,
        isRead: false,
      ),
      MessageThread(
        id: '2',
        name: 'GDG Team',
        lastMessage: 'Meeting at 3 PM today. Don\'t forget!',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        hasUnread: false,
        unreadCount: 0,
        isOnline: false,
        lastMessageFromMe: true,
        isRead: true,
      ),
      MessageThread(
        id: '3',
        name: 'Priya Singh',
        lastMessage: 'Thanks for the code review! 🙏',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        hasUnread: true,
        unreadCount: 1,
        isOnline: true,
        lastMessageFromMe: false,
        isRead: false,
      ),
      MessageThread(
        id: '4',
        name: 'Study Group',
        lastMessage: 'Anyone up for algorithm practice tonight?',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        hasUnread: false,
        unreadCount: 0,
        isOnline: false,
        lastMessageFromMe: false,
        isRead: true,
      ),
      MessageThread(
        id: '5',
        name: 'Arjun Patel',
        lastMessage: 'The hackathon project is looking great!',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
        hasUnread: false,
        unreadCount: 0,
        isOnline: true,
        lastMessageFromMe: true,
        isRead: true,
      ),
    ];
  }
}

class MessageThread {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool hasUnread;
  final int unreadCount;
  final bool isOnline;
  final bool lastMessageFromMe;
  final bool isRead;

  MessageThread({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.hasUnread,
    required this.unreadCount,
    required this.isOnline,
    required this.lastMessageFromMe,
    required this.isRead,
  });
} 