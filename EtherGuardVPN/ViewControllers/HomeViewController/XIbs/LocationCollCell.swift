//
//  LocationCollCell.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/07/01.
//

import UIKit

class LocationCollCell: UICollectionViewCell {

    @IBOutlet weak var CountryFlag: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var onlineStatusView:UIView!

    @IBOutlet weak var connectionType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CountryFlag.makeRounded()  // Assuming you use a UIView extension
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        onlineStatusView.layer.cornerRadius = onlineStatusView.frame.size.width / 2
        onlineStatusView.clipsToBounds = true
        self.enableFocusBorder()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        CountryFlag.image = nil
        countryName.text = nil
        cityName.text = nil
    }

    func configure(flagImage: UIImage?, country: String, city: String) {
        CountryFlag.image = flagImage
        countryName.text = country
        cityName.text = city
    }
}

