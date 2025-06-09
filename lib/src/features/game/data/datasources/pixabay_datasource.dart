import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pixel_flip/src/core/error/exceptions.dart';

abstract class PixabayDataSource {
  Future<List<String>> searchImages(String query, {int perPage = 30});
}

class PixabayDataSourceImpl implements PixabayDataSource {
  static const String _baseUrl = 'https://pixabay.com/api/';

  // In a real app, move this to a secure storage or environment variable
  static const String _apiKey = String.fromEnvironment('pixabay_api_key');
  final http.Client client;

  PixabayDataSourceImpl({required this.client});

  @override
  Future<List<String>> searchImages(String query, {int perPage = 30}) async {
    try {
      final request = Uri.parse(
        '$_baseUrl?key=$_apiKey&q=${Uri.encodeQueryComponent(query)}&per_page=$perPage&image_type=photo',
      );
      final response = await client.get(request);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('hits')) {
          final hits = data['hits'] as List;
          // Extract image URLs from the response
          return hits
              .map<String>((hit) => hit['webformatURL'] as String)
              .toList();
        }
        return [];
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException('Invalid API key');
      } else if (response.statusCode == 429) {
        throw const RateLimitExceededException('API rate limit exceeded');
      } else {
        throw ServerException('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Failed to connect to the server: $e');
    }
  }
}
