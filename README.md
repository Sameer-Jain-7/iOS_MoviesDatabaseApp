
# Movie Database App

A comprehensive iOS application to browse, search, and view details of movies based on the provided movies.json file. This app allows users to explore movies by year, genre, directors, and actors, with an intuitive UI to view detailed information including ratings from multiple sources.

## Features

- **Browse Movies by Categories:**
  - Year
  - Genre
  - Directors
  - Actors
  - All Movies

- **Search Movies:** Users can search for movies by title, genre, actor, or director.

- **Detailed Movie Information:** View details like poster, title, plot, cast & crew, release date, genre, and ratings.

- **Custom Rating View:** Select a rating source (IMDB, Rotten Tomatoes, Metacritic) to see the rating value.

## UI Features

- **Expandable/Collapsible Sections:** Tap on each category to expand or collapse the list of related values.
- **Movie List Cells:** Display movie thumbnail, title, language, and year.
- **Search Functionality:** Show matched movies based on the search query and reset to categories when cleared.


## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/Movies_Database_App.git
    cd Movies_Database_App
    ```

2. Open the project in Xcode:
    ```sh
    open Movies_Database_App.xcodeproj
    ```

3. Build and run the project on a simulator or device.

## Usage

### Browsing Movies

- **Categories:** Open the app and select a category (Year, Genre, Directors, Actors) to see related movies.
  - Each category expands to show values like specific years, genres, directors, or actors.
  - Tap on a value to view a list of movies associated with that value.

- **All Movies:** Shows a list of all movies with thumbnails, titles, languages, and years.

### Searching Movies

- **Search Bar:** Use the search bar to find movies by title, genre, actor, or director.
  - Display all movies containing the search query in any of these fields.
  - Clear the search to return to the category view.

### Viewing Movie Details

- **Movie Details Screen:** Tap on a movie to view detailed information.
  - Poster, title, plot, cast & crew, release date, genre, and ratings are displayed.
  - Select the rating source (IMDB, Rotten Tomatoes, Metacritic) to see the rating value.

## Development

### Prerequisites

- Xcode 12 or later
- iOS 13.0 or later

### Contributing

1. Fork the repository.
2. Create a new branch:
    ```sh
    git checkout -b feature-name
    ```
3. Make your changes and commit them:
    ```sh
    git commit -m 'Add some feature'
    ```
4. Push to the branch:
    ```sh
    git push origin feature-name
    ```
5. Create a new Pull Request.


## Author

Created by SAMEER JAIN
