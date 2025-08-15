



import Foundation
import Alamofire

enum VPNAPI: URLRequestConvertible {
    case login(email: String, password: String, device_id: String)
    case getServer(platform: String, token: String)
    case getUser(token: String)

    var baseURL: String {
        return APIConstants.baseURL
    }

    var path: String {
        switch self {
        case .login:
            return "/api/login"
        case .getServer:
            return "/api/servers"
        case .getUser:
            return "/api/user"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .getServer, .getUser: return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .login(let email, let password, let device_id):
            return ["email": email, "password": password, "device_id": device_id]
        case .getServer(let platform, _):
            return ["platform": platform]
        case .getUser:
            return nil
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .login:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        case .getServer(_, let token), .getUser(let token):
            return [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.method = method

        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }

        switch method {
        case .get:
            return try URLEncoding.default.encode(request, with: parameters)
        default:
            return try JSONEncoding.default.encode(request, with: parameters)
        }
    }
}

