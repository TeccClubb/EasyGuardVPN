import Foundation
import NetworkExtension

class VPNManager {
    
    static let shared = VPNManager()  // Shared instance
    
    var vpnManager: NEVPNManager {
        return NEVPNManager.shared()
    }

    var vpnStatus: NEVPNStatus {
        return vpnManager.connection.status
    }

    private let keychainService = KeychainService()
        private init() {
        debugPrint("VPNManager Initialized")
        loadPreferences()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(statusChanged),
            name: .NEVPNStatusDidChange,
            object: nil
        )
    }

    private func loadPreferences() {
        vpnManager.loadFromPreferences { error in
            if let error = error {
                print("Error loading VPN preferences: \(error.localizedDescription)")
            } else {
                print("VPN preferences loaded")
                NotificationCenter.default.post(name: Notification.Name("VPNStatusChanged"), object: nil)
            }
        }
    }

    func connect(
        vpnType: String,
        vpnServer: String,
        vpnUsername: String,
        vpnPassword: String,
        vpnDescription: String?,
        isKillSwitchEnabled: Bool
    ) {
        vpnManager.loadFromPreferences { [weak self] error in
            guard let self = self else { return }
            guard error == nil else {
                print("VPN Preferences error: \(error!.localizedDescription)")
                return
            }

            let passwordKey = "vpn_\(vpnType)_password"
            self.keychainService.saveItem(k: passwordKey, v: vpnPassword)

            let ikev2Protocol = NEVPNProtocolIKEv2()
            ikev2Protocol.username = vpnUsername
            ikev2Protocol.passwordReference = self.keychainService.loadItem(k: passwordKey)
            ikev2Protocol.serverAddress = vpnServer
            ikev2Protocol.remoteIdentifier = vpnServer
            ikev2Protocol.authenticationMethod = .none
            ikev2Protocol.useExtendedAuthentication = true
            ikev2Protocol.disconnectOnSleep = false

            self.vpnManager.protocolConfiguration = ikev2Protocol
            self.vpnManager.localizedDescription = vpnDescription ?? "VPN"
            self.vpnManager.isOnDemandEnabled = false
            self.vpnManager.isEnabled = true

            self.vpnManager.saveToPreferences { error in
                if let error = error {
                    print("Error saving VPN preferences: \(error.localizedDescription)")
                    return
                }
                do {
                    try self.vpnManager.connection.startVPNTunnel()
                } catch {
                    print("Error starting VPN tunnel: \(error.localizedDescription)")
                }
            }
        }
    }

    func disconnect() {
        vpnManager.connection.stopVPNTunnel()
    }

    func getStatusString() -> String {
        switch vpnStatus {
        case .connected: return "Connected"
        case .connecting: return "Connecting"
        case .disconnected: return "Disconnected"
        case .disconnecting: return "Disconnecting"
        case .invalid: return "Invalid"
        case .reasserting: return "Reasserting"
        @unknown default: return "Unknown"
        }
    }

    @objc private func statusChanged() {
        NotificationCenter.default.post(name: Notification.Name("VPNStatusChanged"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
