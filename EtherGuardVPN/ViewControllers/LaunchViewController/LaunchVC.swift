//
//  LaunchVC.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/06/30.
//

import UIKit

import UIKit

class LaunchVC: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
    }

    func startLoading() {
        progressBar.progress = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            self.progressBar.progress += 0.01
            if self.progressBar.progress >= 1.0 {
                timer.invalidate()
                self.showLoginVC()
            }
        }
    }

    func showLoginVC() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

