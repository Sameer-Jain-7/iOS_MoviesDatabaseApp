//
//  MovieDetailsViewController.swift
//  Movies_Database_App
//
//  Created by Sameer on 13/07/24.
//

import Foundation
import UIKit


class MovieDetailsViewController: UIViewController {
    
    var movie: Movie?
    
//    UIElements for movie details page
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var plotScrollView: UIScrollView!
    
    @IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var imdbRatingView: CustomRatingView!
    @IBOutlet weak var internetRatingView: CustomRatingView!
    @IBOutlet weak var rottenTomatoesRatingView: CustomRatingView!
    @IBOutlet weak var metacriticRatingView: CustomRatingView!
    
    @IBOutlet weak var castLabelHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Every Title gets fitted in the space provided
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        updateCastLabelHeight()
        
        if let movie = movie {
//           Adding the texts to labels
            titleLabel.text = movie.Title
            plotLabel.text = movie.Plot
            let actorsList = movie.Actors.components(separatedBy: ", ")
            let actorsText = actorsList.joined(separator: "\n")
            castLabel.text = actorsText
            castLabel.text = actorsText
            genreLabel.text = "Genre:\n"+movie.Genre
            releaseDateLabel.text = "Release Date:\n"+movie.Released
            
            let movieVC = MovieViewController()
            guard let url = URL(string: movie.Poster) else {
                return
            }
            
//            Load the image from URL
            movieVC.loadImageFromURL(url) { [weak self] (image) in
                if let image = image {
                    self?.posterImageView.image = image
                } else {
                    print("Failed to load image from URL: \(url)")
                }
            }
            
            let plotLabelSize = plotLabel.sizeThatFits(CGSize(width: plotLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            
            
            plotScrollView.contentSize = CGSize(width: plotScrollView.frame.width, height: plotLabelSize.height)
            
            ratingSegmentedControl.addTarget(self, action: #selector(ratingSourceChanged(_:)), for: .valueChanged)
            
            setupRatingViews()
        }
    }
    
    @objc func ratingSourceChanged(_ sender: UISegmentedControl) {
        updateRatingViews()
    }
    
    
//    function to setup ratings
    func setupRatingViews() {
        guard let movie = movie else { return }
        
        // Hide all rating views initially
        internetRatingView.isHidden = true
        rottenTomatoesRatingView.isHidden = true
        metacriticRatingView.isHidden = true
        imdbRatingView.isHidden = true
        
        for rating in movie.Ratings {
            switch rating.Source {
            case "Internet Movie Database":
                internetRatingView.source = "Internet Movie Database"
                internetRatingView.value = rating.Value
            case "Rotten Tomatoes":
                rottenTomatoesRatingView.source = "Rotten Tomatoes"
                rottenTomatoesRatingView.value = rating.Value
            case "Metacritic":
                metacriticRatingView.source = "Metacritic"
                metacriticRatingView.value = rating.Value
            default:
                break
            }
        }
        imdbRatingView.source = "IMDB"
        imdbRatingView.value = movie.imdbRating
        
        updateRatingViews()
    }
    
    
//    function to update ratings
    
    func updateRatingViews() {
        
        internetRatingView.isHidden = true
        rottenTomatoesRatingView.isHidden = true
        metacriticRatingView.isHidden = true
        imdbRatingView.isHidden = true
        
        let selectedSource = ratingSegmentedControl.titleForSegment(at: ratingSegmentedControl.selectedSegmentIndex)
               
              
        
        // switch to show the selected rating view
        switch selectedSource {
        case "Internet Movie Database":
            if internetRatingView.value != "0.0" {
                internetRatingView.isHidden = false
            }
        case "Rotten Tomatoes":
            if rottenTomatoesRatingView.value != "0.0" {
                rottenTomatoesRatingView.isHidden = false
            }
        case "Metacritic":
            if metacriticRatingView.value != "0.0" {
                metacriticRatingView.isHidden = false
            }
        case "IMDB":
            if imdbRatingView.value != "0.0" {
                imdbRatingView.isHidden = false
            }
        default:
            break
        }
        
    }
    
    
//    function to calculate height with respect to number of actors
    func calculateCastLabelHeight() -> CGFloat {
        guard let actors = movie?.Actors else { return 0 }
        
        // Create attributed string with the same font and width as castLabel
        let font = castLabel.font ?? UIFont.systemFont(ofSize: 17) // Default font if not set
        let maxWidth = castLabel.frame.size.width
        let text = actors.replacingOccurrences(of: ", ", with: "\n")
        let size = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes = [NSAttributedString.Key.font: font]
        let boundingRect = NSString(string: text).boundingRect(with: size,
                                                              options: options,
                                                              attributes: attributes,
                                                              context: nil)
        
        return boundingRect.height + 10
    }

    // function tp update castLabel height constraint based on calculated height
    func updateCastLabelHeight() {
        let height = calculateCastLabelHeight()
        castLabelHeightConstraint.constant = height
        view.layoutIfNeeded()
    }
    
    
    
}

