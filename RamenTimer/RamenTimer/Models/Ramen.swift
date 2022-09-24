//
//  Ramen.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/08/30.
//

import UIKit

enum RamenBrands: CaseIterable {
    case nongSim
    case ottugi
    case samyang
    case pulmuwon
    case paldo
}

enum SpicyLevel {
    case mild
    case spicy
    case verySpicy
}

enum RamenColor {
    case red
    case orange
    case yellow
    case green
    case blue
    case navy
    case purple
    case pink
    
}

struct Ramen {
    
    var number: Int?
    var image: UIImage?
    var title: String?
    var suggestedTime: Int?
    var settingTime: Int?
    var water: Int?
    var memo: String?
    var brand: RamenBrands?
    var bookmark: Bool = false
    var spicyLevel: SpicyLevel?
    var color: RamenColor?
    
}

