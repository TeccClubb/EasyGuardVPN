//
//  Extensions.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/06/23.
//

import Foundation
import UIKit

extension UIImageView{
    func makeRounded(borderWidth: CGFloat = 2, borderColor: UIColor = .white) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}


extension UIView {
    func enableFocusBorder(cornerRadius: CGFloat = 10, borderColor: UIColor = .red, borderWidth: CGFloat = 4) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
    }
    
    func applyFocusStyle(_ isFocused: Bool, borderColor: UIColor = .red) {
        self.layer.borderColor = isFocused ? borderColor.cgColor : UIColor.clear.cgColor
    }
    
}

extension UIViewController {

    func showAlert(title: String, message: String, duration: TimeInterval = 2.0) {
        let alertView = UIView()
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        alertView.layer.cornerRadius = 20
        alertView.clipsToBounds = true

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 22)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        self.view.addSubview(alertView)

        // Constraints
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 600),
            alertView.heightAnchor.constraint(equalToConstant: 250),

            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20)
        ])

        // Animate and dismiss
        alertView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            alertView.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.3, animations: {
                alertView.alpha = 0
            }, completion: { _ in
                alertView.removeFromSuperview()
            })
        }
    }
}





