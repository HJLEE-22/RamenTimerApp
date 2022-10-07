//
//  RamenData+CoreDataProperties.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/09/06.
//
//

import Foundation
import CoreData


extension RamenData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RamenData> {
        return NSFetchRequest<RamenData>(entityName: "RamenData")
    }

    @NSManaged public var bookmark: Bool
    @NSManaged public var memo: String?
    @NSManaged public var number: String?
    @NSManaged public var settingTime: String?
    @NSManaged public var suggestedTime: String?
    @NSManaged public var title: String?
    @NSManaged public var water: String?
    @NSManaged public var spicyLevel: String?
    @NSManaged public var brand: String?
    @NSManaged public var color: String?
    @NSManaged public var order: Int16

}

extension RamenData : Identifiable {

}
