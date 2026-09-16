/// Eine Abschlag-/Tee-Konfiguration (Name, Farbe, Course-Rating, Slope, Par).
class TeeInfo {
  final String name;
  final String color;
  final double cr;
  final int slope;
  final int par;

  const TeeInfo({
    required this.name,
    required this.color,
    required this.cr,
    required this.slope,
    required this.par,
  });
}

/// Stammdaten des Golfclubs (für "Über diese App" inkl. der ehemaligen
/// Kontakt-Inhalte, siehe PFLICHTENHEFT.md §3 der Navigations-Entscheidung).
class CourseInfo {
  final String clubName;
  final String address;
  final String phone;
  final String email;
  final String web;
  final String greenfeeFrom;
  final Map<String, TeeInfo> tees;

  const CourseInfo({
    required this.clubName,
    required this.address,
    required this.phone,
    required this.email,
    required this.web,
    required this.greenfeeFrom,
    required this.tees,
  });
}
