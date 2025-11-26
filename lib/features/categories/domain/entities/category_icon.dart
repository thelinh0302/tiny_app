/// Domain entity representing a category icon option a user can select.
///
/// This sits in the feature domain layer and is decoupled from
/// any specific remote provider (ImageKit, etc.).
class CategoryIcon {
  final String id;
  final String name;
  final String thumbnailUrl;

  const CategoryIcon({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
  });
}
