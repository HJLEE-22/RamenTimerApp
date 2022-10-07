//
//  CallJSON.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/09/13.
//

import Foundation

struct RamenModelCodable: Codable {
    
    var number: String?
    var title: String?
    var settingTime: String?
    var suggestedTime: String?
    var water: String?
    var memo: String?
    var bookmark: Bool = false
    var brand: String?
    var spicyLevel: String?
    var color: String?
    var order: Int16
    
//    enum CodingKeys: String, CodingKey {
//        case number = "number"
//        case title = "title"
//        case suggestedTime = "suggestedTime"
//        case settingTime = "settingTime"
//        case water = "water"
//        case memo = "memo"
//        case brand = "brand"
//        case bookmark = "bookmark"
//        case spicyLevel = "spicyLevel"
//        case color = "color"
//    }
//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        number = try values.decode(Int.self, forKey: .number)
//        title = try values.decode(String.self, forKey: .title)
//        suggestedTime = try values.decode(Int.self, forKey: .suggestedTime)
//        settingTime = try values.decode(Int.self, forKey: .settingTime)
//        water = try values.decode(Int.self, forKey: .water)
//        memo = try values.decode(String.self, forKey: .memo)
//        brand = try values.decode(String.self, forKey: .brand)
//        bookmark = try values.decode(Bool.self, forKey: .bookmark)
//        spicyLevel = try values.decode(Int.self, forKey: .spicyLevel)
//        color = try values.decode(String.self, forKey: .color)
//    }
//    
    func encode(to encoder: Encoder) throws {
        
    }
    
}




