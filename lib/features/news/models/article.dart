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