import 'package:dio/dio.dart';
import 'package:finly_app/core/error/exceptions.dart';
import 'package:finly_app/core/network/dio_client.dart';
import 'package:finly_app/features/analytics/data/models/analytics_summary_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsSummaryModel> getSummary({
    bool all = true,
    String? startDate,
    String? endDate,
  });
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final DioClient client;

  AnalyticsRemoteDataSourceImpl({required this.client});

  @override
  Future<AnalyticsSummaryModel> getSummary({
    bool all = true,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final query = <String, dynamic>{'all': all};
      if (startDate != null) query['startDate'] = startDate;
      if (endDate != null) query['endDate'] = endDate;

      final Response res = await client.get(
        '/analytics/summary',
        queryParameters: query,
      );
      return AnalyticsSummaryModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch analytics summary');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
