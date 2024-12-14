class Friend {
  final String id;
  final String name;
  final String profilePicUrl;
  final int upcomingEventsCount;

  Friend({
    required this.id,
    required this.name,
    required this.profilePicUrl,
    required this.upcomingEventsCount,
  });

  // Convert Friend object to map (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profilePicUrl': profilePicUrl,
      'upcomingEventsCount': upcomingEventsCount,
    };
  }

  // Convert map to Friend object (Firebase or SQLite)
  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'],
      name: map['name'],
      profilePicUrl: map['profilePicUrl'],
      upcomingEventsCount: map['upcomingEventsCount'] ?? 0,
    );
  }
}
