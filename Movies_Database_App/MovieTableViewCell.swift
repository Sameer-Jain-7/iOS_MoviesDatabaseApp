//
//  MovieTableViewCell.swift
//  Movies_Database_App
//
//  Created by Sameer on 13/07/24.
//

import Foundation
import UIKit

class MovieTableViewCell: UITableViewCell {
    
//    UIElements for movie details cell
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
