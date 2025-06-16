class CirclePost {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final List<String> images;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final List<String> tags;
  final String? location;
  final bool isLiked;

  const CirclePost({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.images,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.tags,
    this.location,
    this.isLiked = false,
  });

  CirclePost copyWith({
    String? id,
    String? authorName,
    String? authorAvatar,
    String? content,
    List<String>? images,
    DateTime? timestamp,
    int? likes,
    int? comments,
    List<String>? tags,
    String? location,
    bool? isLiked,
  }) {
    return CirclePost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      images: images ?? this.images,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
      location: location ?? this.location,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory CirclePost.fromJson(Map<String, dynamic> json) {
    return CirclePost(
      id: json['id'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String,
      content: json['content'] as String,
      images: List<String>.from(json['images'] as List),
      timestamp: DateTime.parse(json['timestamp'] as String),
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      tags: List<String>.from(json['tags'] as List),
      location: json['location'] as String?,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'images': images,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'tags': tags,
      'location': location,
      'isLiked': isLiked,
    };
  }
} 