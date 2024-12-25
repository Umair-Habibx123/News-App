import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsProviderApi with ChangeNotifier {
  final String apiKey = dotenv.env['API_KEY_UMAIR_1'] ?? 'No API key found';

  String _category = 'general'; // Default category
  String _source = ''; // Source ID for news
  int _page = 1; // Current page for pagination
  bool _isFetching = false; // Loading state
  String _errorMessage = ''; // Store error messages
  String get errorMessage => _errorMessage; // Getter for the error message

  List<dynamic> _articles = [];
  List<dynamic> get articles => _articles;
  bool get isFetching => _isFetching; // Getter for loading state

  NewsProviderApi({String? category, String? source}) {
    if (category != null) {
      _category = category;
    }
    if (source != null) {
      _source = source;
    }
    fetchNews();
  }

  Future<void> fetchNews() async {
    if (_isFetching) return; // Prevent multiple fetch calls
    _isFetching = true;
    notifyListeners();

    try {
      final apiUrl = _buildApiUrl();
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['articles'] == null || data['articles'].isEmpty) {
          _errorMessage = 'No news articles found.';
        } else {
          _errorMessage = '';
          final List<dynamic> newArticles = data['articles'];

          // Add sourceName to each article
          for (var article in newArticles) {
            article['sourceName'] = article['source']['name'];
          }

          _articles.addAll(newArticles);
          _page++;
        }
      } else if (response.statusCode == 401) {
        _errorMessage = 'Invalid API Key. Please update your credentials.';
      } else if (response.statusCode == 429) {
        _errorMessage = 'API Rate limit exceeded. Try again later.';
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['message'] ?? 'Error fetching news.';
      }
    } catch (e) {
      print('Error: $e');
      // _errorMessage = 'Error connecting to server. Details: $e';
      notifyListeners();
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  String _buildApiUrl() {
    if (_source.isNotEmpty) {
      return 'https://newsapi.org/v2/top-headlines?sources=$_source&apiKey=$apiKey&page=$_page';
    } else {
      return 'https://newsapi.org/v2/top-headlines?category=$_category&language=en&apiKey=$apiKey&page=$_page';
    }
  }

  void setCategory(String category) {
    _category = category;
    _source = ''; // Reset source
    _page = 1; // Reset page
    _articles = []; // Clear articles
    fetchNews();
  }

  void setSource(String source) {
    _source = source;
    _category = ''; // Reset category
    _page = 1; // Reset page
    _articles = []; // Clear articles
    fetchNews();
  }
}
