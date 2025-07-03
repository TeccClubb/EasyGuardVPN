//
//  NetworkManager.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/07/02.
//

import Foundation
import Alamofire

class VPNNetworkManager {
    static let shared = VPNNetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(_ api: VPNAPI, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(api)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
