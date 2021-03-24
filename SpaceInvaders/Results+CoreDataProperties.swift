//
//  Results+CoreDataProperties.swift
//  SpaceInvaders
//
//  Created by administrator on 24.03.2021.
//  Copyright © 2021 administrator. All rights reserved.
//
//

import Foundation
import CoreData


extension Results {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Results> {
        return NSFetchRequest<Results>(entityName: "Results")
    }

    @NSManaged public var result: String?
    @NSManaged public var points: Int32

}
