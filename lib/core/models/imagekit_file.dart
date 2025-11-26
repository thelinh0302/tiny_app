/// Model representing an ImageKit file entry.
///
/// In this app we only care about the `name` and `thumbnail` URL
/// returned by the ImageKit files API.
class ImageKitFileModel {
  final String name;

  /// Normalized thumbnail URL without ImageKit query parameters / transforms.
  /// Example:
  ///   input:  https://.../rent_icon.svg?updatedAt=...&tr=n-ik_ml_thumbnail
  ///   stored: https://.../rent_icon.svg
  final String thumbnail;

  const ImageKitFileModel({required this.name, required this.thumbnail});

  factory ImageKitFileModel.fromJson(Map<String, dynamic> json) {
    final rawThumbnail = json['thumbnail'] as String? ?? '';
    return ImageKitFileModel(
      name: json['name'] as String? ?? '',
      thumbnail: _stripQueryParams(rawThumbnail),
    );
  }

  /// Remove any query string from the URL (everything after '?').
  static String _stripQueryParams(String url) {
    final int qIndex = url.indexOf('?');
    if (qIndex == -1) return url;
    return url.substring(0, qIndex);
  }
}
