//
//  Company+CoreDataProperties.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 17.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//
//

import Foundation
import CoreData


extension CompanyCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompanyCoreData> {
        return NSFetchRequest<CompanyCoreData>(entityName: "Company")
    }

    public var id: Int16? {
        get {
            self.willAccessValue(forKey: "id")
            let value = self.primitiveValue(forKey: "id") as? Int
            self.didAccessValue(forKey: "id")

            return (value != nil) ? Int16(value!) : nil
        }
        set {
            self.willChangeValue(forKey: "id")

            let value : Int? = (newValue != nil) ? Int(newValue!) : nil
            self.setPrimitiveValue(value, forKey: "id")

            self.didChangeValue(forKey: "id")
        }
    }
    @NSManaged public var name: String?

}
