import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id;
  final String title;
  final String content; // Markdown content
  final String excerpt;
  final String? coverImageUrl;
  final String authorId;
  final String authorName;
  final String? authorImageUrl;
  final List<String> tags;
  final String category;
  final bool isPublished;
  final bool isFeatured;
  final DateTime publishedAt;
  final DateTime? updatedAt;
  final DateTime createdAt;
  final int readTimeMinutes;
  final int views;
  final int likes;
  final String? seoTitle;
  final String? seoDescription;
  final String slug;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    this.coverImageUrl,
    required this.authorId,
    required this.authorName,
    this.authorImageUrl,
    this.tags = const [],
    required this.category,
    this.isPublished = false,
    this.isFeatured = false,
    required this.publishedAt,
    this.updatedAt,
    required this.createdAt,
    this.readTimeMinutes = 5,
    this.views = 0,
    this.likes = 0,
    this.seoTitle,
    this.seoDescription,
    required this.slug,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      excerpt: json['excerpt'] as String,
      coverImageUrl: json['coverImageUrl'] as String?,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorImageUrl: json['authorImageUrl'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      category: json['category'] as String,
      isPublished: json['isPublished'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readTimeMinutes: json['readTimeMinutes'] as int? ?? 5,
      views: json['views'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      seoTitle: json['seoTitle'] as String?,
      seoDescription: json['seoDescription'] as String?,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'excerpt': excerpt,
      'coverImageUrl': coverImageUrl,
      'authorId': authorId,
      'authorName': authorName,
      'authorImageUrl': authorImageUrl,
      'tags': tags,
      'category': category,
      'isPublished': isPublished,
      'isFeatured': isFeatured,
      'publishedAt': publishedAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'readTimeMinutes': readTimeMinutes,
      'views': views,
      'likes': likes,
      'seoTitle': seoTitle,
      'seoDescription': seoDescription,
      'slug': slug,
    };
  }

  // Firestore serialization methods
  factory Article.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Article(
      id: documentId,
      title: data['title'] as String,
      content: data['content'] as String,
      excerpt: data['excerpt'] as String,
      coverImageUrl: data['coverImageUrl'] as String?,
      authorId: data['authorId'] as String,
      authorName: data['authorName'] as String,
      authorImageUrl: data['authorImageUrl'] as String?,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      category: data['category'] as String,
      isPublished: data['isPublished'] as bool? ?? false,
      isFeatured: data['isFeatured'] as bool? ?? false,
      publishedAt: (data['publishedAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      readTimeMinutes: data['readTimeMinutes'] as int? ?? 5,
      views: data['views'] as int? ?? 0,
      likes: data['likes'] as int? ?? 0,
      seoTitle: data['seoTitle'] as String?,
      seoDescription: data['seoDescription'] as String?,
      slug: data['slug'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'excerpt': excerpt,
      'coverImageUrl': coverImageUrl,
      'authorId': authorId,
      'authorName': authorName,
      'authorImageUrl': authorImageUrl,
      'tags': tags,
      'category': category,
      'isPublished': isPublished,
      'isFeatured': isFeatured,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
      'createdAt': Timestamp.fromDate(createdAt),
      'readTimeMinutes': readTimeMinutes,
      'views': views,
      'likes': likes,
      'seoTitle': seoTitle,
      'seoDescription': seoDescription,
      'slug': slug,
    };
  }

  Article copyWith({
    String? id,
    String? title,
    String? content,
    String? excerpt,
    String? coverImageUrl,
    String? authorId,
    String? authorName,
    String? authorImageUrl,
    List<String>? tags,
    String? category,
    bool? isPublished,
    bool? isFeatured,
    DateTime? publishedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
    int? readTimeMinutes,
    int? views,
    int? likes,
    String? seoTitle,
    String? seoDescription,
    String? slug,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      excerpt: excerpt ?? this.excerpt,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isPublished: isPublished ?? this.isPublished,
      isFeatured: isFeatured ?? this.isFeatured,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      seoTitle: seoTitle ?? this.seoTitle,
      seoDescription: seoDescription ?? this.seoDescription,
      slug: slug ?? this.slug,
    );
  }

  // Utility getters
  bool get hasCoverImage => coverImageUrl != null && coverImageUrl!.isNotEmpty;
  bool get hasAuthorImage => authorImageUrl != null && authorImageUrl!.isNotEmpty;
  String get formattedReadTime => '$readTimeMinutes min read';
  
  // Generate excerpt from content if not provided
  static String generateExcerpt(String content, {int maxLength = 150}) {
    final plainText = content
        .replaceAll(RegExp(r'[#*_`\[\]()]+'), '') // Remove markdown
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .trim();
    
    if (plainText.length <= maxLength) return plainText;
    
    final truncated = plainText.substring(0, maxLength);
    final lastSpace = truncated.lastIndexOf(' ');
    
    return lastSpace > 0 
        ? '${truncated.substring(0, lastSpace)}...'
        : '$truncated...';
  }

  // Generate slug from title
  static String generateSlug(String title) {
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '') // Remove special chars
        .replaceAll(RegExp(r'\s+'), '-') // Replace spaces with hyphens
        .replaceAll(RegExp(r'-+'), '-') // Replace multiple hyphens with single
        .trim();
  }

  // Calculate estimated read time based on content
  static int calculateReadTime(String content, {int wordsPerMinute = 200}) {
    final wordCount = content.split(RegExp(r'\s+')).length;
    final readTime = (wordCount / wordsPerMinute).ceil();
    return readTime < 1 ? 1 : readTime;
  }
}

// Article categories enum
enum ArticleCategory {
  technology('Technology'),
  events('Events'),
  tutorials('Tutorials'),
  news('News'),
  community('Community'),
  career('Career'),
  projects('Projects'),
  resources('Resources');

  const ArticleCategory(this.displayName);
  final String displayName;
}

// Article status enum
enum ArticleStatus {
  draft('Draft'),
  published('Published'),
  archived('Archived'),
  scheduled('Scheduled');

  const ArticleStatus(this.displayName);
  final String displayName;
} 