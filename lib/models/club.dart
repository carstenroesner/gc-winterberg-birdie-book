/// Ein Schläger im Schläger-Set des Nutzers. [min]/[max] sind die typische
/// Schlagweite in Metern; `null` bei Schlägern ohne sinnvolle Distanzangabe
/// (z. B. Putter).
class Club {
  final String id;
  final String name;
  final String category;
  final int? min;
  final int? max;

  const Club({
    required this.id,
    required this.name,
    required this.category,
    required this.min,
    required this.max,
  });

  Club copyWith({
    String? id,
    String? name,
    String? category,
    int? min,
    int? max,
    bool clearMin = false,
    bool clearMax = false,
  }) {
    return Club(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      min: clearMin ? null : (min ?? this.min),
      max: clearMax ? null : (max ?? this.max),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'min': min,
        'max': max,
      };

  factory Club.fromJson(Map<String, dynamic> json) => Club(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        min: json['min'] as int?,
        max: json['max'] as int?,
      );
}
