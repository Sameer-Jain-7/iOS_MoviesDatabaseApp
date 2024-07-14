//
//  ViewController.swift
//  Movies_Database_App
//
//  Created by Sameer on 13/07/24.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    
    //    Variables to be used
    var moviesList: [Movie] = []
    var filteredMovies: [Movie] = []
    var isSearching = false
    var isFiltered = false
    var expandedSections = Set<Int>()
    
    
    //    UI Elements to be used
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        SearchBar.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "otherCell")
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "movieCell")
        
        loadMovies()
    }
    
    //    Loading all the movie list from Json
    
    func loadMovies() {
        if let movieJson = Bundle.main.url(forResource: "movies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: movieJson)
                moviesList = try JSONDecoder().decode([Movie].self, from: data)
            } catch {
                print("There was error while fetching movie list : \(error) ")
            }
        }
    }
    
    // 5 sections for Year, Genre, Directors, Actors and All Movies
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching || isFiltered {
            return 1
        } else {
            return 5
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredMovies.count
        }else if isFiltered {
            return filteredMovies.count + 1
        }
        else {
            
            if expandedSections.contains(section) {
                switch section {
                case 0: return moviesList.map { $0.Year }.unique().count + 1
                case 1: return moviesList.flatMap { $0.Genre.components(separatedBy: ",") }.map { $0.trimmingCharacters(in: .whitespaces)}.unique().count  + 1
                case 2: return moviesList.flatMap { $0.Director.components(separatedBy: ",") }.map { $0.trimmingCharacters(in: .whitespaces)}.unique().count  + 1
                case 3: return moviesList.flatMap { $0.Actors.components(separatedBy: ",") }.map { $0.trimmingCharacters(in: .whitespaces)}.unique().count  + 1
                case 4: return moviesList.count  + 1
                default: return 0
                }
            } else {
                return 1
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  isSearching || isFiltered {
            if indexPath.row == 0 && isFiltered {
                let cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath)
                cell.textLabel?.text = "Back to All Movies"
                return cell
            } else {
                let movieIndex = isFiltered ? indexPath.row - 1 : indexPath.row
                let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
                let movie = filteredMovies[movieIndex]
                configureCell(cell, with: movie)
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath)
                switch indexPath.section {
                case 0:
                    cell.textLabel?.text = "Year"
                case 1:
                    cell.textLabel?.text = "Genre"
                case 2:
                    cell.textLabel?.text = "Directors"
                case 3:
                    cell.textLabel?.text = "Actors"
                case 4:
                    cell.textLabel?.text = "All Movies"
                default:
                    break
                }
                return cell
            } else {
                if expandedSections.contains(indexPath.section) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath)
                    switch indexPath.section {
                    case 0:
                        let years = moviesList.map { $0.Year }.unique()
                        cell.textLabel?.text = "\(years[indexPath.row - 1])"
                    case 1:
                        let genres = moviesList.flatMap { $0.Genre.components(separatedBy: ",") }.map { $0.trimmingCharacters(in: .whitespaces)}.unique()
                        cell.textLabel?.text = genres[indexPath.row - 1]
                    case 2:
                        let directorData = moviesList.flatMap { $0.Director.components(separatedBy: ",") }
                        let naReplacement = "Unidentified Directors"
                        let filtereddirectors = directorData.map { $0.trimmingCharacters(in: .whitespaces) == "N/A" ? naReplacement : $0.trimmingCharacters(in: .whitespaces) }.unique()
                        cell.textLabel?.text = filtereddirectors[indexPath.row - 1]
                    case 3:
                        let actorData = moviesList.flatMap { $0.Actors.components(separatedBy: ",") }
                        let naReplacement = "Movies with Unidentified Actors"
                        let filteredActors = actorData.map { $0.trimmingCharacters(in: .whitespaces) == "N/A" ? naReplacement : $0.trimmingCharacters(in: .whitespaces) }.unique()

                        cell.textLabel?.text = filteredActors[indexPath.row - 1]
                        
                    case 4:
                        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
                        let movie = moviesList[indexPath.row - 1]
                        configureCell(cell, with: movie)
                        return cell
                    default:
                        break
                    }
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath)
                    cell.textLabel?.text = ""
                    return cell
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            let movie = filteredMovies[indexPath.row]
            showMovieDetails(movie)
        } else if isFiltered && indexPath.row == 0 {
            isFiltered = false
            expandedSections.removeAll()
            tableView.reloadData()
        }else {
            tableView.deselectRow(at: indexPath, animated: true)
            
            if indexPath.row == 0 {
                // switch between expanded and collapsed state
                let section = indexPath.section
                if expandedSections.contains(section) {
                    expandedSections.remove(section)
                    tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                } else {
                    expandedSections.removeAll()
                    expandedSections.insert(section)
                    tableView.reloadData()
                    tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
                }
            }
            else {
                switch indexPath.section {
                case 0:
                    let year = moviesList.map { $0.Year }.unique()[indexPath.row-1]
                    let moviesByYear = moviesList.filter { $0.Year == year }
                    print("moviesByYear",moviesByYear.count,year)
                    showMovies(moviesByYear)
                case 1:
                    let genre = moviesList.flatMap { $0.Genre.components(separatedBy: ",") }.map { $0.trimmingCharacters(in: .whitespaces)}.unique()[indexPath.row-1]
                    let moviesByGenre = moviesList.filter { $0.Genre.contains(genre) }
                    showMovies(moviesByGenre)
                case 2:
                    let directorName = moviesList.flatMap { $0.Director.components(separatedBy: ",") }.map { $0.trimmingCharacters(in: .whitespaces)}.unique()[indexPath.row-1]
                    let moviesByDirector = moviesList.filter { $0.Director.contains(directorName) }
                    showMovies(moviesByDirector)
                case 3:
                    let actor = moviesList.flatMap { $0.Actors.components(separatedBy: ",") }.map { $0.trimmingCharacters(in: .whitespaces)}.unique()[indexPath.row-1]
                    let moviesByActor = moviesList.filter { $0.Actors.contains(actor) }
                    showMovies(moviesByActor)
                case 4:
                    let movie = moviesList[indexPath.row-1]
                    showMovieDetails(movie)
                default:
                    break
                }
            }
            
            
        }
    }
    
    
//    function to search movies by title/genre/actor/director
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            filteredMovies = moviesList.filter { movie in
                return movie.Title.lowercased().contains(searchText.lowercased()) ||
                movie.Genre.lowercased().contains(searchText.lowercased()) ||
                movie.Director.lowercased().contains(searchText.lowercased()) ||
                movie.Actors.lowercased().contains(searchText.lowercased())
            }
            if filteredMovies.isEmpty {
                print("No Filtered Movies")
            }
            tableView.reloadData()
        }
    }
    
//    funciton for Cancel button on Search Bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        tableView.reloadData()
    }
    
    
//    fucntion to configure the movie detail cell
    func configureCell(_ cell: MovieTableViewCell, with movie: Movie) {
        cell.titleLabel.text = movie.Title
        cell.langLabel.text = "Language: " + movie.Language
        cell.yearLabel.text = "Year: " + movie.Year
        if let url = URL(string: movie.Poster) {
            loadImageFromURL(url) { image in
                DispatchQueue.main.async {
                    cell.posterImageView.image = image
                }
            }
        }
    }
    
    
//    Function to show Movie list page on bases of year, genre, director and actor
    func showMovies(_ movies: [Movie]) {
        
        filteredMovies.removeAll()
        filteredMovies.append(contentsOf: movies)
        
        guard let moviesListVC = self.storyboard?.instantiateViewController(withIdentifier: "MoviesListViewController") as? MoviesListViewController else {
            print("Failed to instantiate MovieDetailsViewController from storyboard")
            return
        }
        moviesListVC.movieList = filteredMovies
        
        guard let navigationController = self.navigationController else {
            print("Error: navigationController is nil")
            return
        }
        
        navigationController.pushViewController(moviesListVC, animated: true)
        
    }
    
    
//    funciton to show movie details page
    func showMovieDetails(_ movie: Movie) {

        guard let movieDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else {
            print("Failed to instantiate MovieDetailsViewController from storyboard")
            return
        }
        movieDetailsVC.movie = movie
        
        guard let navigationController = self.navigationController else {
            print("Error: navigationController is nil")
            return
        }
        navigationController.pushViewController(movieDetailsVC, animated: true)
    }
    
//    function to load image from URLs of poster
    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("URL : ",url)
            if let error = error {
                print("Error loading image:", error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received while loading image")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    
}

