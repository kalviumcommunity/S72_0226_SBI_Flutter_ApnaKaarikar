/// Artist model
class Artist {
  final String id;
  final String name;
  final String craftType;
  final String location;
  final String profilePhoto;
  final double rating;
  final int reviewCount;

  const Artist({
    required this.id,
    required this.name,
    required this.craftType,
    required this.location,
    required this.profilePhoto,
    required this.rating,
    required this.reviewCount,
  });
}
