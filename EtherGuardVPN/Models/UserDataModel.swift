//
//  UserDataModel.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/07/02.
//

struct UserResponse: Codable {
    let status: Bool
    let user: UserData
}

struct UserData: Codable {
    let name: String
    let email: String
}
