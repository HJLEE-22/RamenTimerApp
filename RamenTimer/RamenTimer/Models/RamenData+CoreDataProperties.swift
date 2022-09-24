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
    @NSManaged public var number: Int16
    @NSManaged public var settingTime: Int16
    @NSManaged public var suggestedTime: Int16
    @NSManaged public var title: String?
    @NSManaged public var water: Int16
    @NSManaged public var spicyLevel: Int16
    @NSManaged public var brand: String?
    @NSManaged public var color: String?

}

extension RamenData : Identifiable {

}
