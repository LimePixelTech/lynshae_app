class BondingLevel {
  final String name;
  final int minPoints;
  final String description;

  const BondingLevel({
    required this.name,
    required this.minPoints,
    required this.description,
  });

  static const List<BondingLevel> levels = [
    BondingLevel(
      name: '初识',
      minPoints: 0,
      description: '初次相遇，开始建立连接',
    ),
    BondingLevel(
      name: '熟悉',
      minPoints: 100,
      description: '逐渐熟悉彼此',
    ),
    BondingLevel(
      name: '信赖',
      minPoints: 500,
      description: '建立了深厚的信任',
    ),
    BondingLevel(
      name: '家人',
      minPoints: 1500,
      description: '成为不可或缺的家人',
    ),
  ];

  static BondingLevel getLevelForPoints(int points) {
    for (int i = levels.length - 1; i >= 0; i--) {
      if (points >= levels[i].minPoints) {
        return levels[i];
      }
    }
    return levels.first;
  }

  static int getPointsToNextLevel(int currentPoints) {
    final currentLevel = getLevelForPoints(currentPoints);
    final currentIndex = levels.indexOf(currentLevel);
    if (currentIndex < levels.length - 1) {
      return levels[currentIndex + 1].minPoints - currentPoints;
    }
    return 0;
  }

  static double getProgressToNextLevel(int currentPoints) {
    final currentLevel = getLevelForPoints(currentPoints);
    final currentIndex = levels.indexOf(currentLevel);
    if (currentIndex >= levels.length - 1) return 1.0;

    final nextLevel = levels[currentIndex + 1];
    final pointsInCurrentLevel = currentPoints - currentLevel.minPoints;
    final pointsNeeded = nextLevel.minPoints - currentLevel.minPoints;
    return pointsInCurrentLevel / pointsNeeded;
  }
}

class DailyTask {
  final String id;
  final String title;
  final String description;
  final int rewardPoints;
  final String iconName;
  bool isCompleted;
  int currentProgress;
  final int targetProgress;

  DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.iconName,
    this.isCompleted = false,
    this.currentProgress = 0,
    required this.targetProgress,
  });
}

class BondingState {
  int totalPoints;
  List<DailyTask> dailyTasks;
  List<String> unlockedActions;

  BondingState({
    this.totalPoints = 0,
    List<DailyTask>? dailyTasks,
    List<String>? unlockedActions,
  })  : dailyTasks = dailyTasks ?? [],
        unlockedActions = unlockedActions ?? [];

  BondingLevel get currentLevel => BondingLevel.getLevelForPoints(totalPoints);

  double get progressToNextLevel =>
      BondingLevel.getProgressToNextLevel(totalPoints);

  int get pointsToNextLevel =>
      BondingLevel.getPointsToNextLevel(totalPoints);

  void addPoints(int points) {
    totalPoints += points;
  }

  void completeTask(String taskId) {
    final task = dailyTasks.firstWhere((t) => t.id == taskId);
    if (!task.isCompleted) {
      task.isCompleted = true;
      addPoints(task.rewardPoints);
    }
  }
}
