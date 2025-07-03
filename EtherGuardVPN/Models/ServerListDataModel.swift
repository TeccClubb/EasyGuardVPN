



import Foundation

// MARK: - VPNResponse
struct VPNResponse: Codable {
    let status: Bool
    let servers: [VPNServer]
}

// MARK: - VPNServer
struct VPNServer: Codable {
    let id: Int
    let image: String
    let name: String
    let platforms: PlatformSupport
    let type: String
    let category: String
    let status: Bool
    let createdAt: String
    let subServers: [SubServer]

    enum CodingKeys: String, CodingKey {
        case id, image, name, platforms, type, category, status
        case createdAt = "created_at"
        case subServers = "sub_servers"
    }
}

// MARK: - PlatformSupport
struct PlatformSupport: Codable {
    let android: Bool
    let ios: Bool
    let macos: Bool
    let windows: Bool
}

// MARK: - SubServer
struct SubServer: Codable {
    let id: Int
    let serverId: Int
    let name: String
    let status: Int
    let vpsServer: VPSServer

    enum CodingKeys: String, CodingKey {
        case id, name, status
        case serverId = "server_id"
        case vpsServer = "vps_server"
    }
}

// MARK: - VPSServer
struct VPSServer: Codable {
    let id: Int
    let name: String
    let ipAddress: String
    let domain: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case ipAddress = "ip_address"
        case domain
    }
}
