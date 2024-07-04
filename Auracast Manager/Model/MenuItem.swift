//
//  MenuItem.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/9.
//

import SwiftUI


enum MainMenuType {
    case manage
    case funtion
    case about
}


struct MainMenuItem: Identifiable, Hashable {
    var id = UUID()
    var type: MainMenuType
    var name: String
    var menus: [MenuItem]
}

enum MenuType {
    case pods
    case transmitter
    case preference
    case magicLab
    case share
    case about
    case aboutBanfi
    case premium
}

struct MenuItem: Identifiable, Hashable {
    var id = UUID()
    var type: MenuType
    var name: String
    var image: String
}
