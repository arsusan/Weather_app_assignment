class SearchHistory {
  final String id;
  final String userId;
  final String cityName;
  final DateTime timestamp;

  SearchHistory({
    required this.id,
    required this.userId,
    required this.cityName,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'cityName': cityName, 'timestamp': timestamp};
  }

  factory SearchHistory.fromMap(String id, Map<String, dynamic> map) {
    return SearchHistory(
      id: id,
      userId: map['userId'],
      cityName: map['cityName'],
      timestamp: map['timestamp'].toDate(),
    );
  }
}
