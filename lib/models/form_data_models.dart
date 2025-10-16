class Board {
  final String uuid;
  final String name;

  Board({
    required this.uuid,
    required this.name,
  });

  @override
  String toString() {
    return name;
  }
}

class Grade {
  final String uuid;
  final String name;

  Grade({
    required this.uuid,
    required this.name,
  });

  @override
  String toString() {
    return name;
  }
}

class Subject {
  final String uuid;
  final String name;

  Subject({
    required this.uuid,
    required this.name,
  });

  @override
  String toString() {
    return name;
  }
}

class LPDuration {
  final int minutes;

  const LPDuration({
    required this.minutes,
  });

  @override
  String toString() {
    return '${minutes.toString().padLeft(2, '0')} Minutes';
  }
}