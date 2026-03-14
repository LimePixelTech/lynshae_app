class DailyTask {
  final String title;
  final String description;
  final int rewardPoints;
  final bool isCompleted;
  final String iconName;

  const DailyTask({
    required this.title,
    required this.description,
    required this.rewardPoints,
    this.isCompleted = false,
    this.iconName = 'task',
  });

  DailyTask copyWith({
    String? title,
    String? description,
    int? rewardPoints,
    bool? isCompleted,
    String? iconName,
  }) {
    return DailyTask(
      title: title ?? this.title,
      description: description ?? this.description,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      isCompleted: isCompleted ?? this.isCompleted,
      iconName: iconName ?? this.iconName,
    );
  }
}