class DebateFormat {
  final String fullName;
  final String shortName;
  final List<List<int>> timings;

  DebateFormat({
    required this.fullName,
    required this.shortName,
    required this.timings,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'shortName': shortName,
      'timings': timings,
    };
  }

  factory DebateFormat.fromJson(Map<String, dynamic> json) {
    return DebateFormat(
      fullName: json['fullName'] as String,
      shortName: json['shortName'] as String,
      timings: (json['timings'] as List)
          .map((row) => (row as List).cast<int>())
          .toList(),
    );
  }

  @override
  String toString() {
    return 'DebateFormat(fullName: $fullName, shortName: $shortName, timings: $timings)';
  }

  // Helper method to check if format has reply speech
  bool get hasReplySpeech {
    if (timings.length < 5) return false;
    return timings[4][0] > 0 || timings[4][1] > 0;
  }
}