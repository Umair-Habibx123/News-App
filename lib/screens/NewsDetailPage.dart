import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailPage({super.key, required this.article});

  static const platform = MethodChannel('com.example.newsdetail/url_launcher');

  Future<void> _openUrlAndroid(String url) async {
    try {
      await platform.invokeMethod('openUrl', {'url': url});
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  // void _openUrl(BuildContext context, String url) {
  //   if (url.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("URL is empty.")),
  //     );
  //     return;
  //   }

  //   if (Theme.of(context).platform == TargetPlatform.android) {
  //     _openUrlAndroid(url);
  //   } else {
  //     // Fallback for non-Android platforms
  //     _launchUrlFallback(url, context);
  //   }
  // }

  // Future<void> _launchUrlFallback(String url, BuildContext context) async {
  //   try {
  //     final uri = Uri.parse(url);
  //     if (!await canLaunchUrl(uri)) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Cannot launch URL: $url")),
  //       );
  //       return;
  //     }
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: ${e.toString()}")),
  //     );
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "News Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Image
            if (article['urlToImage'] != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.network(
                  article['urlToImage'],
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // News Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                article['title'] ?? 'No Title Available',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // News Source and Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      article['sourceName'] ?? 'Unknown Source',
                      style: const TextStyle(fontSize: 14),
                    ),
                    backgroundColor: Colors.blue[100],
                  ),
                  Text(
                    article['publishedAt'] != null
                        ? DateTime.parse(article['publishedAt'])
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                        : 'Unknown Date',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // News Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                article['content'] ??
                    'No content available for this news article.',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // URL Section
            if (article['url'] != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  // onTap: () => _openUrl(context, article['url']),
                  onTap: () => _openUrlAndroid(article['url']),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Text(
                        'Read Full Article',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
