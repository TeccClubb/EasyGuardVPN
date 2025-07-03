import UIKit
import Alamofire

class AccountInfo: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var backViewBtn : UIView!
    @IBOutlet weak var profileView : UIView!
    
    @IBOutlet weak var usageStack1 : UIStackView!
    @IBOutlet weak var usageStack2:UIStackView!
    
    @IBOutlet weak var usageLbl : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.makeRounded()
        fetchUserData()
        
        let backBtnTapped = UITapGestureRecognizer(target: self, action: #selector(backViewTapped))
        backViewBtn.isUserInteractionEnabled = true
        backViewBtn.addGestureRecognizer(backBtnTapped)
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(profileTap)
        
        usageStack1.isHidden = true
        usageStack2.isHidden = true
        usageLbl.isHidden = true
        
    }


    @objc func backViewTapped() {
        self.navigationController?.popViewController(animated: true)

    }
    
    @objc func profileViewTapped() {
        
    }
    
    
    
//    @IBAction func backButton(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func DelAccountBtn(_ sender: Any) {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }

    // MARK: - API Call
    
    func fetchUserData() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("❌ Auth token not found")
            return
        }

        VPNNetworkManager.shared.request(.getUser(token: token)) { (result: Result<UserResponse, AFError>) in
            switch result {
            case .success(let userResponse):
                DispatchQueue.main.async {
                    self.userName.text = userResponse.user.name
                    self.userEmail.text = userResponse.user.email
                }
            case .failure(let error):
                print("❌ Failed to get user data: \(error.localizedDescription)")
            }
        }
    }

    
    
}
