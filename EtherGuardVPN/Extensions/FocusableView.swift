//
//  viewFocus.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/07/03.
//

import Foundation
import UIKit

class FocusableView: UIView {
    override var canBecomeFocused: Bool {
        return true
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if context.nextFocusedView == self {
            // Gained focus
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 4
        } else if context.previouslyFocusedView == self {
            // Lost focus
            self.layer.borderWidth = 0
        }
    }
}
