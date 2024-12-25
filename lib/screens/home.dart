import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/screens/NewsDetailPage.dart';
import 'package:news_app/screens/category.dart';
import 'package:news_app/services/NewsProviderApi.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
  }

  void _checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    var hasInternet = !connectivityResult.contains(ConnectivityResult.none);
    setState(() {
      _hasInternet = hasInternet;
    });
    if (!_hasInternet) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('No Internet'),
        ),
        body: Center(
          child: TextButton(
            onPressed: _checkInternetConnectivity,
            child: const Text('Retry'),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 86, 30, 190),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.apps,
                color: Colors.white, // Set the icon color to white
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CategoryScreen(),
                  ),
                );
              },
            ),
            const Text(
              'News',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (String result) {
                Provider.of<NewsProviderApi>(context, listen: false)
                    .setSource(result);
              },
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'bbc-news',
                  child: Text('BBC News'),
                ),
                const PopupMenuItem<String>(
                  value: 'ary-news',
                  child: Text('ARY News'),
                ),
                const PopupMenuItem<String>(
                  value: 'al-jazeera-english',
                  child: Text('Al-Jazeera English'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Horizontal Scrollable List of News Cards
          SizedBox(
            height: 350.0,
            child: Consumer<NewsProviderApi>(
              builder: (context, newsProvider, _) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newsProvider.articles.length,
                itemBuilder: (BuildContext context, int index) {
                  var article = newsProvider.articles[index];
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
                      width: 300.0,
                      margin: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10.0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        image: DecorationImage(
                          image: article['urlToImage'] != null
                              ? NetworkImage(article['urlToImage'])
                              : const AssetImage('assets/image_not_found.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  article['title'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      article['sourceName'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14.0,
                                      ),
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
                                        color: Colors.white70,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Vertical Scrollable List of News Articles
          Expanded(
            child: Consumer<NewsProviderApi>(
              builder: (context, newsProvider, child) {
                if (newsProvider.isFetching && newsProvider.articles.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show a Snackbar if there's an error
                if (newsProvider.errorMessage.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(newsProvider.errorMessage),
                        action: SnackBarAction(
                          label: 'Retry',
                          onPressed: () {
                            Provider.of<NewsProviderApi>(context, listen: false)
                                .fetchNews();
                          },
                        ),
                      ),
                    );
                  });
                }

                return ListView.builder(
                  itemCount: newsProvider.articles.length + 1,
                  itemBuilder: (context, index) {
                    if (index == newsProvider.articles.length) {
                      // Show loading indicator at the end
                      return Center(
                        child: newsProvider.isFetching
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: newsProvider.fetchNews,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blueGrey[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: const Text('Load More'),
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
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (article['urlToImage'] != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                ),
                                child: Image.network(
                                  article['urlToImage'],
                                  fit: BoxFit.cover,
                                  height: 100.0,
                                  width: 100.0,
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
                                      Container(
                                    height: 100.0,
                                    width: 100.0,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.error,
                                        size: 40.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                ),
                                child: Container(
                                  height: 100.0,
                                  width: 100.0,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 40.0,
                                      color: Colors.grey,
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
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
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
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
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
}
