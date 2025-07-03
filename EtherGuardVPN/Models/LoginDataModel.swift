//
//  LoginDataModel.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/07/02.
//

import Foundation

struct LoginResponse: Codable {
    let status: Bool
    let message: String
    let user: User
    let accessToken: String
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case user
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let slug: String
    let email: String
    let lastLogin: String?
    let registeredAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case email
        case lastLogin = "last_login"
        case registeredAt = "registered_at"
    }
}

