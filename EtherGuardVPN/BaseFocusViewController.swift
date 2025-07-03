//
//  BaseViewController.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/06/30.
//

import UIKit

class BaseFocusViewController: UIViewController {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        coordinator.addCoordinatedAnimations {
            if let next = context.nextFocusedView {
                next.applyFocusStyle(true)
                next.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
            if let previous = context.previouslyFocusedView {
                previous.applyFocusStyle(false)
                previous.transform = .identity
            }
        }
    }
}


