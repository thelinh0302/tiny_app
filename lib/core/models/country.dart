import 'package:equatable/equatable.dart';

/// Simple country model used for phone number country selection.
///
/// Based on RestCountries v3 API response for
/// `https://restcountries.com/v3.1/all?fields=flags,cca2,idd`.
class Country extends Equatable {
  final String code; // ISO 3166-1 alpha-2 (cca2)
  final String? flagPngUrl;
  final String? flagSvgUrl;
  final String? iddRoot; // e.g. "+9"
  final List<String> iddSuffixes; // e.g. ["63"]

  const Country({
    required this.code,
    required this.flagPngUrl,
    required this.flagSvgUrl,
    required this.iddRoot,
    required this.iddSuffixes,
  });

  /// Returns the primary international dialing code such as "+963".
  /// If multiple suffixes exist, the first one is used.
  String? get primaryDialCode {
    if (iddRoot == null || iddRoot!.isEmpty || iddSuffixes.isEmpty) {
      return null;
    }
    return '${iddRoot!}${iddSuffixes.first}';
  }

  factory Country.fromRestCountriesJson(Map<String, dynamic> json) {
    final flags = json['flags'] as Map<String, dynamic>?;
    final idd = json['idd'] as Map<String, dynamic>?;

    final root = idd != null ? (idd['root'] as String?) : null;
    final suffixesDynamic =
        idd != null ? idd['suffixes'] as List<dynamic>? : null;
    final suffixes =
        suffixesDynamic
            ?.where((e) => e is String && e.isNotEmpty)
            .cast<String>()
            .toList(growable: false) ??
        const <String>[];

    return Country(
      code: (json['cca2'] as String?)?.toUpperCase() ?? '',
      flagPngUrl: flags != null ? flags['png'] as String? : null,
      flagSvgUrl: flags != null ? flags['svg'] as String? : null,
      iddRoot: root,
      iddSuffixes: suffixes,
    );
  }

  @override
  List<Object?> get props => [
    code,
    flagPngUrl,
    flagSvgUrl,
    iddRoot,
    iddSuffixes,
  ];
}
