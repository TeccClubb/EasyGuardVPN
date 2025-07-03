//
//  SettingModel.swift
//  EtherGuardVPN
//
//  Created by Macbook on 2025/06/30.
//

import Foundation

struct SettingItem {
    let title: String
    let subtitle: String?
    let iconName: String
    let hasToggle: Bool
    let isEnabled:Bool
}

struct SettingsSection {
    let title: String
    let items: [SettingItem]
}
