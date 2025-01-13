# News App

A Flutter application that allows users to browse the latest news articles from various categories using the [News API](https://newsapi.org/). The app fetches news articles, displays them with images, titles, dates, and sources, and offers an interactive UI for a seamless user experience. Download APK Here [APK](https://github.com/Umair-Habibx123/News-App/raw/main/APK/app-release.apk)

## Features

- **Real-time News Updates**: Get the latest news from multiple categories such as Technology, Health, Sports, and more.
- **News Articles with Images**: Display news articles along with relevant images, titles, dates, and source names.
- **Categories Filtering**: Browse articles by categories to quickly find the topics that interest you.
- **Search Functionality**: Easily search for news articles based on keywords.
- **User-friendly Interface**: A clean and intuitive design built with Flutter for an optimal mobile experience.

## Getting Started

To get this project up and running on your local machine, follow these steps:

### Prerequisites

Ensure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install)
- A code editor like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- An emulator or physical device for running the app

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/Umair-Habibx123/News-App
    ```

2. Navigate to the project directory:
    ```bash
    cd news_app
    ```

3. Install dependencies:
    ```bash
    flutter pub get
    ```

4. Set up an API key:
    - Visit [NewsAPI](https://newsapi.org/) and sign up to get your free API key.
    - Add your API key to the `lib/services/NewsProviderApi.dart` file in the project:
      ```dart
      const String apiKey = 'YOUR_API_KEY';
      ```

5. Run the app:
    ```bash
    flutter run
    ```

## Features in Detail

- **Fetching News**: The app fetches articles using the News API, which returns articles in JSON format.
- **Displaying News**: Articles are displayed in a list, with images, titles, source names, and publication dates.
- **Search Functionality**: Users can search for articles based on specific keywords.
- **Category Selection**: Filter news by categories like Business, Entertainment, General, Health, Science, Sports, Technology, etc.

## API Documentation

This app utilizes the [News API](https://newsapi.org/) to fetch news articles. You can find more details on the available endpoints, request parameters, and usage limits in the API documentation.

## License

This project is open-source and available under the MIT License. See the [LICENSE](LICENSE) file for more details.
