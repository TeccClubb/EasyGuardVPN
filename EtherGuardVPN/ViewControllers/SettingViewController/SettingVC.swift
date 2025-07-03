//
//  SettingVC.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/06/30.
//

import UIKit
import Alamofire

class SettingVC: BaseFocusViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var settingTable: UITableView!
    @IBOutlet weak var profileImg : UIImageView!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var backViewBtn: UIView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var useremail : UILabel!
    
    var sections: [SettingsSection] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingTable.dataSource = self
        self.settingTable.delegate = self
        
        settingTable.register(UINib(nibName: "SettingTableCell", bundle: nil), forCellReuseIdentifier: "SettingTableCell")
        
        setupData()
//        backButton.enableFocusBorder()
        profileView.enableFocusBorder()

        profileImg.makeRounded(borderWidth: 2, borderColor: UIColor(named: "logoColor")! )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
            profileView.isUserInteractionEnabled = true
            profileView.addGestureRecognizer(tapGesture)
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(backTapped))
            backViewBtn.isUserInteractionEnabled = true
        backViewBtn.addGestureRecognizer(viewTapGesture)
    }
    
    @objc func profileTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountInfo") as! AccountInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor(named: "sectionColor")
            header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold) // Optional styling
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return sections[section].title
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as? SettingTableCell else {
                   return UITableViewCell()
               }

               let item = sections[indexPath.section].items[indexPath.row]
               cell.configure(with: item)
               return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingTableCell else { return }

        // If the item has a toggle, simulate a toggle on tap
        let item = sections[indexPath.section].items[indexPath.row]
        if item.hasToggle {
            cell.toggleSwitchManually()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // Set your desired height
    }


    
    func setupData() {
            sections = [
                SettingsSection(title: "Connection Settings", items: [
                    SettingItem(title: "Kill Switch", subtitle: "Block internet if VPN disconnects", iconName: "killSwitch", hasToggle: true, isEnabled: true),
                    SettingItem(title: "Auto Connect", subtitle: "Connect VPN when app starts", iconName: "autoConnect", hasToggle: true, isEnabled: false),
                    SettingItem(title: "Protocols", subtitle: "Choose apps to bypass VPN", iconName: "protocols", hasToggle: false, isEnabled: false)
                ]),
                SettingsSection(title: "Privacy & Legal ", items: [
                    SettingItem(title: "Privacy Policy", subtitle: "view your privacy policy", iconName:"privacy" , hasToggle: false, isEnabled: false),
                    SettingItem(title: "Logout", subtitle: "Sign out from your account ", iconName: "logout", hasToggle: false, isEnabled: false),
                ])
            ]
        }
    
    
    
//    @IBAction func backButton(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//
//
//    }
    
    @IBAction func profileDetails(_ sender :UIButton ){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountInfo") as! AccountInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
