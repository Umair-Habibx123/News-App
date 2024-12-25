import 'package:flutter/material.dart';
import 'package:news_app/screens/NewsDetailPage.dart';
import 'package:news_app/services/NewsProviderApi.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _selectedCategory = 'General'; // Default selected category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 86, 30, 190),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.white, // White color for title text
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // White color for back arrow
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryButton('General',
                    isSelected: _selectedCategory == 'General'),
                _buildCategoryButton('Entertainment',
                    isSelected: _selectedCategory == 'Entertainment'),
                _buildCategoryButton('Health',
                    isSelected: _selectedCategory == 'Health'),
                _buildCategoryButton('Technology',
                    isSelected: _selectedCategory == 'Technology'),
                _buildCategoryButton('Sports',
                    isSelected: _selectedCategory == 'Sports'),
                _buildCategoryButton('Science',
                    isSelected: _selectedCategory == 'Science'),
              ],
            ),
          ),
          Expanded(
            child: Consumer<NewsProviderApi>(
              builder: (context, newsProvider, child) {
                if (newsProvider.isFetching && newsProvider.articles.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: newsProvider.articles.length +
                      1, // Add one for the loading indicator
                  itemBuilder: (context, index) {
                    if (index == newsProvider.articles.length) {
                      // Show loading indicator at the end
                      return Center(
                        child: newsProvider.isFetching
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: newsProvider.fetchNews,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 86, 30, 190),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Load More',
                                  style: TextStyle(
                                    color: Colors.white, // White color
                                    fontWeight: FontWeight.bold, // Bold text
                                  ),
                                ),
                              ),
                      );
                    }
                    final article = newsProvider.articles[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                NewsDetailPage(article: article),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            if (article['urlToImage'] != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.network(
                                  article['urlToImage'],
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              )
                            else
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey[
                                      300], // Background color for the "image not found" icon
                                  child: const Center(
                                    child: Icon(
                                      Icons
                                          .image_not_supported, // Icon to display when image is not found
                                      size: 40,
                                      color: Colors.grey, // Color of the icon
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['title'] ?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          article['source']['name'] ??
                                              'Unknown Source',
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          article['publishedAt'] != null
                                              ? DateTime.parse(
                                                      article['publishedAt'])
                                                  .toLocal()
                                                  .toString()
                                                  .split(' ')[0]
                                              : 'Unknown Date',
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
        Provider.of<NewsProviderApi>(context, listen: false)
            .setCategory(category.toLowerCase());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color:
                isSelected ? Colors.deepPurple : Colors.grey.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
