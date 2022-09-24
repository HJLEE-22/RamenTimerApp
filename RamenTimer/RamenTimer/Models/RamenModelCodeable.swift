//
//  CallJSON.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/09/13.
//

import Foundation

class RamenModelCodable: Codable {
    
    var number: String?
    var title: String?
    var suggestedTime: String?
    var settingTime: String?
    var water: String?
    var memo: String?
    var brand: String?
    var bookmark: Bool = false
    var spicyLevel: String?
    var color: String?
    
    enum CodingKeys: String, CodingKey {
        case number = "Number"
        case title = "Title"
        case suggestedTime = "SuggestedTime"
        case settingTime = "SettingTime"
        case water = "Water"
        case memo = "Memo"
        case brand = "Brand"
        case bookmark = "Bookmark"
        case spicyLevel = "SpicyLevel"
        case color = "Color"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        number = try values.decode(String.self, forKey: .number)
        title = try values.decode(String.self, forKey: .title)
        suggestedTime = try values.decode(String.self, forKey: .suggestedTime)
        settingTime = try values.decode(String.self, forKey: .settingTime)
        water = try values.decode(String.self, forKey: .water)
        memo = try values.decode(String.self, forKey: .memo)
        brand = try values.decode(String.self, forKey: .brand)
        bookmark = try values.decode(Bool.self, forKey: .bookmark)
        spicyLevel = try values.decode(String.self, forKey: .spicyLevel)
        color = try values.decode(String.self, forKey: .color)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
}




