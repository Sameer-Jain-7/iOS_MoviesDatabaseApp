//
//  MoviesListViewController.swift
//  Movies_Database_App
//
//  Created by Sameer on 13/07/24.
//

import Foundation
import UIKit

class MoviesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    var movieList: [Movie] = []

    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "movieCell")
        
        // Reload the tableView with the movie list
        movieTableView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return movieList.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
           let movieVC = MovieViewController()
           let movie = movieList[indexPath.row]
           movieVC.configureCell(cell as! MovieTableViewCell, with: movie)
           return cell
       }

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedMovie = movieList[indexPath.row]
           showMovieDetails(selectedMovie)
           tableView.deselectRow(at: indexPath, animated: true)
       }
       
       // Function to show movie details
       func showMovieDetails(_ movie: Movie) {
           guard let movieDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else {
               print("Failed to instantiate MovieDetailsViewController from storyboard")
               return
           }
           
           movieDetailsVC.movie = movie
           
           guard let navigationController = self.navigationController else {
               print("Error: No navigation controller found.")
               return
           }
           
           navigationController.pushViewController(movieDetailsVC, animated: true)
       }
   }
