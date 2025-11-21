import 'package:dio/dio.dart';

import 'package:finly_app/core/models/country.dart';

/// Service to fetch country dialing information and flags
/// using the public RestCountries API.
///
/// API: https://restcountries.com/v3.1/all?fields=flags,cca2,idd
class RestCountriesService {
  final Dio _dio;

  RestCountriesService({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://restcountries.com'));

  /// Fetch all countries with flags and dialing info.
  ///
  /// Returns a list of [Country] filtered to only those that
  /// have a usable primary dial code.
  Future<List<Country>> fetchCountries() async {
    final response = await _dio.get<List<dynamic>>(
      '/v3.1/all',
      queryParameters: <String, dynamic>{'fields': 'flags,cca2,idd'},
    );

    final data = response.data ?? <dynamic>[];
    final List<Country> countries =
        data
            .where((e) => e is Map<String, dynamic>)
            .map(
              (e) => Country.fromRestCountriesJson(e as Map<String, dynamic>),
            )
            .where((c) => c.primaryDialCode != null)
            .toList();

    // Sort by dialing code then by country code for a stable order
    countries.sort(
      (a, b) => (a.primaryDialCode ?? '').compareTo(b.primaryDialCode ?? ''),
    );

    return countries;
  }
}
