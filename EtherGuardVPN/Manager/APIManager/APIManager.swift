//
//  NetworkManager.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/07/02.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func request<T: Decodable>(_ api: VPNAPI, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(api)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
