# 🎥 FilmList

**FilmList** is a sleek iOS app that lets you browse, discover, and rate movies – all in one place.  
Whether you're a casual viewer or a film buff, FilmList makes it easy to keep track of your favorites and share your ratings.

<!-- ![FilmList screenshot](link-to-screenshot-if-available.png) -->

## ✨ About FilmList

FilmList is designed to be your personal movie companion. It pulls in real-time movie details from TMDB (The Movie Database),  
including release dates, posters, and overviews. You can explore new releases, classics, and hidden gems,  
then add your own ratings to build a personalized list of recommendations.

Not only can you give each movie a star rating, but FilmList also supports **fractional star ratings** –  
perfect for those times when 3 stars just doesn’t cut it!

## 🚀 Features

- **Real-time movie data**: See up-to-date info about your favorite films.
- **Supabase backend**: Secure and fast data storage that keeps your ratings and lists in sync.
- **Dynamic UI**: Enjoy a smooth experience with visually appealing animations.
- **Fractional rating system**: Rate movies precisely – no more rounding to whole stars!
- **Cross-platform-ready**: Designed for possible future expansion to macOS and web.

**Who’s it for?**  
FilmList is for anyone who loves movies and wants an easy, beautiful way to explore and track them.  
If you’re tired of cluttered movie databases or want to keep your own personal star ratings, this app is for you!

## 📱 Technologies

| Tool / Framework    | Role                       |
|----------------------|---------------------------|
| Swift (SwiftUI)      | Frontend UI and logic     |
| TMDB API             | Real-time movie metadata  |
| Supabase (PostgreSQL)| Backend storage           |
| UIKit (optional)     | For extended custom views |

## 🚧 Getting Started

1. **Clone the repo**:
    ```bash
    git clone https://github.com/sophlzy3/film-list.git
    cd FilmList
    ```
2. **Install dependencies** (if using Swift Package Manager):
    ```bash
    open film-list.xcodeproj
    ```
3. **Configure TMDB API Key**:
    - Add your TMDB API key in `Config.swift` (not committed to repo).
4. **Run in Xcode**:
    - Select your simulator/device and build the app!

## 📂 Database Schema

Here’s the schema for the `movies` table:

| Column          | Type     | Notes                  |
|------------------|----------|------------------------|
| `id`            | INTEGER  | Primary key            |
| `title`         | TEXT     | Movie title            |
| `original_title`| TEXT     | Original language title|
| `overview`      | TEXT     | Brief summary          |
| `backdrop_path` | TEXT     | Image URL (optional)   |
| `poster_path`   | TEXT     | Poster URL (optional)  |
| `release_date`  | TEXT     | Release date (optional)|

## 📦 Deployment

<!-- - **Supabase**: Hosted at [https://your-project.supabase.co](https://your-project.supabase.co) -->
- **iOS**: Deployed via TestFlight for beta testing.

---

**Made with ❤️ by [Sophie](https://github.com/sophlzy3)**

---

