class University {
  final String id;
  final String name;
  final String? country;
  final String? logoUrl;

  const University({
    required this.id,
    required this.name,
    this.country,
    this.logoUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is University &&
      other.id == id &&
      other.name == name &&
      other.country == country &&
      other.logoUrl == logoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      country.hashCode ^
      logoUrl.hashCode;
  }
}
