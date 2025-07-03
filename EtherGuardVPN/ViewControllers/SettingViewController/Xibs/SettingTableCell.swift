//
//  SettingTableCell.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/06/30.
//

import UIKit

class SettingTableCell: UITableViewCell {

    @IBOutlet weak var settingImg: UIImageView!
    
    @IBOutlet weak var settingTitle: UILabel!
    
    @IBOutlet weak var settingSubTitle: UILabel!
    
    @IBOutlet weak var toggleButton: ToggleButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with item: SettingItem) {
        settingTitle.text = item.title
        settingSubTitle.text = item.subtitle
        settingImg.image = UIImage(named: item.iconName)
        
        if item.hasToggle {
            toggleButton.isHidden = false
            toggleButton.isOn = item.isEnabled 
        } else {
            toggleButton.isHidden = true
        }
    }
    
    func toggleSwitchManually() {
        toggleButton.toggleState() 
    }



    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        coordinator.addCoordinatedAnimations {
            if self.isFocused {
                self.contentView.layer.borderColor = UIColor.red.cgColor
                self.contentView.layer.borderWidth = 3
            } else {
                self.contentView.layer.borderWidth = 0
            }
        }
    }
}
