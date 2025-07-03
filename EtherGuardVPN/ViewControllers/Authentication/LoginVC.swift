


import UIKit
import Alamofire

class LoginVC: BaseFocusViewController {

    @IBOutlet weak var usernameTxtFeild: UITextField!
    @IBOutlet weak var passwrodTxtFeild: UITextField!
    
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var hidePassBtn: UIButton!
    @IBOutlet weak var rememberPassBtn: UIButton!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var loginBtnView: FocusableView!
    
    @IBOutlet weak var txtFeildView1: UIView!
    
    @IBOutlet weak var txtFeildView2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Enable focus border for all focusable views
        usernameTxtFeild.enableFocusBorder()
        passwrodTxtFeild.enableFocusBorder()
        
        loginBtnView.layer.cornerRadius = 10
        loginBtnView.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
            loginBtnView.isUserInteractionEnabled = true
        loginBtnView.addGestureRecognizer(tapGesture)
        
//        loginLbl.font = UIFont(name: "Inter-Variable", size: 20)
        
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        loginBtn.enableFocusBorder()
//
//    }
    
    override func viewDidLayoutSubviews() {
        txtFeildView1.layer.borderWidth = 2
        txtFeildView1.layer.borderColor = UIColor.darkGray.cgColor
        
        txtFeildView2.layer.borderWidth = 2
        txtFeildView2.layer.borderColor = UIColor.darkGray.cgColor

    }

    
    @objc func loginTapped() {
        let email = usernameTxtFeild.text ?? ""
        let password = passwrodTxtFeild.text ?? ""

        guard !email.isEmpty, !password.isEmpty else {
            self.showAlert(title: "Error", message: "Please enter email and password")
            return
        }

        // Get device ID
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown-device-id"
        debugPrint(deviceID)

        // Make API request
        VPNNetworkManager.shared.request(.login(email: email, password: password, device_id: deviceID)) { (result: Result<LoginResponse, AFError>) in
            switch result {
            case .success(let response):
                print("Login successful for \(response.user.name)")
                
                UserDefaults.standard.setValue(response.accessToken, forKey: "authToken")

                DispatchQueue.main.async {
                    self.showAlert(title: "Success", message: response.message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }

            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Login Failed", message: "Invalid credentials or device")
                }
            }
        }
    }
    
    
    
    // MARK: - Navigation

//    @IBAction func loginBtn(_ sender: Any) {
//        let email = usernameTxtFeild.text ?? ""
//        let password = passwrodTxtFeild.text ?? ""
//
//        guard !email.isEmpty, !password.isEmpty else {
//            self.showAlert(title: "Error", message: "Please enter email and password")
//            return
//        }
//
//        // Get device ID
//        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown-device-id"
//        debugPrint(deviceID)
//
//        // Make API request
//        VPNNetworkManager.shared.request(.login(email: email, password: password, device_id: deviceID)) { (result: Result<LoginResponse, AFError>) in
//            switch result {
//            case .success(let response):
//                print("Login successful for \(response.user.name)")
//                
//                UserDefaults.standard.setValue(response.accessToken, forKey: "authToken")
//
//                DispatchQueue.main.async {
//                    self.showAlert(title: "Success", message: response.message)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
//
//            case .failure(let error):
//                print("Login failed: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.showAlert(title: "Login Failed", message: "Invalid credentials or device")
//                }
//            }
//        }
//    }


    
//    func postData(to urlString: String, body: [String: Any]) {
//        guard let url = URL(string: urlString) else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: body)
//        } catch {
//            print("JSON error: \(error)")
//            return
//        }
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                print("Response:", String(data: data, encoding: .utf8) ?? "")
//            } else if let error = error {
//                print("Error:", error)
//            }
//        }.resume()
//    }

}
