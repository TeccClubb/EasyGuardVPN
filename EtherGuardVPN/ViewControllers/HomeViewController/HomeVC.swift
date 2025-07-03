import UIKit
import Alamofire
import NetworkExtension

class HomeVC: BaseFocusViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - IBOutlets
    @IBOutlet weak var profileImgBtn: UIButton!
    @IBOutlet weak var locationCollView: UICollectionView!
    @IBOutlet weak var connectionFlagImg: UIImageView!
    @IBOutlet weak var vpnStatusView: UIView!
    @IBOutlet weak var vpnStartBtn: UIButton!
    @IBOutlet weak var connectedStatus: UILabel!
    @IBOutlet weak var connectedTime: UILabel!
    @IBOutlet weak var connectionLocation: UILabel!
    @IBOutlet weak var ipAddress: UILabel!

    // MARK: - Properties
    var isVPNRunning = false
    var isBorderRed = false
    var vpnTimer: Timer?
    var startTime: Date?
    var server: [VPNServer] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationCollView.dataSource = self
        locationCollView.delegate = self

        let nib = UINib(nibName: "LocationCollCell", bundle: nil)
        locationCollView.register(nib, forCellWithReuseIdentifier: "LocationCollCell")
        locationCollView.backgroundColor = .clear

        profileImgBtn.layer.cornerRadius = profileImgBtn.frame.width / 2
        profileImgBtn.clipsToBounds = true
        vpnStatusView.layer.borderColor = UIColor(named: "logoColor")?.cgColor

        profileImgBtn.enableFocusBorder()
        vpnStartBtn.enableFocusBorder()

        fetchVPNServerList()

        NotificationCenter.default.addObserver(self, selector: #selector(handleVPNStatusChange), name: .init("VPNStatusChanged"), object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        vpnStatusView.layer.cornerRadius = vpnStatusView.frame.size.width / 2
        vpnStatusView.layer.borderWidth = 10
        vpnStatusView.clipsToBounds = true
    }

    // MARK: - Button Actions
    @IBAction func profileBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func vpnStartBtn(_ sender: Any) {
        print("[🔘 BUTTON] VPN Start button tapped. Current VPN running state: \(isVPNRunning)")

        if !isVPNRunning {
            print("[🌐 CONNECT] Trying to connect VPN...")
            VPNManager.shared.connect(
                vpnType: "ikev2",
                vpnServer: "german.tecclubb.com",
                vpnUsername: "vpnuser",
                vpnPassword: "StrongP@ssw0rd",
                vpnDescription: "VPN",
                isKillSwitchEnabled: false
            )
        } else {
            print("[🛑 DISCONNECT] Trying to disconnect VPN...")
            VPNManager.shared.disconnect()
        }
    }

    @objc func handleVPNStatusChange() {
        let status = VPNManager.shared.vpnStatus
        print("[🔄 STATUS CHANGED] New VPN status: \(status.rawValue)")

        DispatchQueue.main.async {
            switch status {
            case .connected:
                print("[✅ CONNECTED] VPN is connected")
                self.connectedStatus.text = "Connected"
                self.updateVPNUI(connected: true)
                self.startVPNStopwatch()
                self.isVPNRunning = true

            case .disconnected, .invalid, .disconnecting:
                print("[❌ DISCONNECTED] VPN is disconnected or invalid")
                self.connectedStatus.text = "Disconnected"
                self.updateVPNUI(connected: false)
                self.stopVPNStopwatch()
                self.isVPNRunning = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.connectedTime.text = "00:00:00"
                }

            case .connecting:
                print("[⏳ CONNECTING] VPN is connecting...")
                self.connectedStatus.text = "Connecting..."

            case .reasserting:
                print("[🔁 REASSERTING] VPN is reasserting...")
                self.connectedStatus.text = "Reasserting..."

            @unknown default:
                print("[⚠️ UNKNOWN] Unknown VPN status")
                self.connectedStatus.text = "Unknown"
            }
        }
    }

    // MARK: - UI Updates
    func updateVPNUI(connected: Bool) {
        let newColor: UIColor = connected ? .red : .green
        let newTitle = connected ? "Disconnect" : "Connect"

        vpnStatusView.layer.borderColor = newColor.cgColor
        vpnStartBtn.setTitle(newTitle, for: .normal)
        isBorderRed = connected
    }

    // MARK: - Timer
    func startVPNStopwatch() {
        startTime = Date()
        connectedTime.text = "00:00:00"

        vpnTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard let start = self.startTime else { return }
            let elapsed = Int(Date().timeIntervalSince(start))

            let hours = elapsed / 3600
            let minutes = (elapsed % 3600) / 60
            let seconds = elapsed % 60

            self.connectedTime.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }

    func stopVPNStopwatch() {
        vpnTimer?.invalidate()
        vpnTimer = nil
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return server.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollCell", for: indexPath) as? LocationCollCell else {
            fatalError("Unable to dequeue LocationCollCell")
        }

        let serverItem = server[indexPath.row]
        cell.countryName.text = serverItem.name
        cell.cityName.text = serverItem.subServers.first?.name ?? "N/A"
        cell.connectionType.text = serverItem.type

        if let url = URL(string: serverItem.image) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let currentCell = collectionView.cellForItem(at: indexPath) as? LocationCollCell {
                            currentCell.CountryFlag.image = image
                        }
                    }
                }
            }.resume()
        }

        cell.CountryFlag.makeRounded(borderWidth: 0, borderColor: .clear)
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedServer = server[indexPath.row]
        print("[📡 SELECTED SERVER] \(selectedServer.name) - \(selectedServer.subServers.first?.name ?? "No SubServer")")

        if let url = URL(string: selectedServer.image) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.connectionFlagImg.image = image
                    }
                }
            }.resume()
        }

        if let city = selectedServer.subServers.first?.name {
            self.connectionLocation.text = "\(selectedServer.name), \(city)"
        } else {
            self.connectionLocation.text = selectedServer.name
        }

        self.ipAddress.text = selectedServer.subServers.first?.vpsServer.ipAddress ?? "0.0.0.0"
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let spacing: CGFloat = 20
        let sectionInsets: CGFloat = 40

        let totalSpacing = (itemsPerRow - 1) * spacing + sectionInsets
        let itemWidth = (collectionView.bounds.width - totalSpacing) / itemsPerRow
        let itemHeight: CGFloat = 120

        return CGSize(width: itemWidth, height: itemHeight)
    }

    // MARK: - API
    func fetchVPNServerList() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("❌ No auth token found")
            return
        }

        VPNNetworkManager.shared.request(.getServer(platform: "ios", token: token)) { (result: Result<VPNResponse, AFError>) in
            switch result {
            case .success(let response):
                print("[✅ SERVER LIST] Fetched \(response.servers.count) servers")
                self.server = response.servers
                DispatchQueue.main.async {
                    self.locationCollView.reloadData()
                }

            case .failure(let error):
                print("❌ Failed to fetch servers: \(error.localizedDescription)")
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
