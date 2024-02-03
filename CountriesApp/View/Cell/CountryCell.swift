//
//  CountryCell.swift
//  CountriesApp
//
//  Created by Mohamed Adel on 03/02/2024.
//

import UIKit

protocol CountryCellProtocol {
    func displayEmoji(_ text: String)
    func displayName(_ text: String)
}

class CountryCell: UITableViewCell {
    
    @IBOutlet weak var countryEmojiLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}

extension CountryCell: CountryCellProtocol {
    func displayEmoji(_ text: String) {
        countryEmojiLabel.text = text
    }
    
    func displayName(_ text: String) {
        countryNameLabel.text = text
    }
}
