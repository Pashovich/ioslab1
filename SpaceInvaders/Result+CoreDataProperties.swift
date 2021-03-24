//
//  Result+CoreDataProperties.swift
//  SpaceInvaders
//
//  Created by administrator on 24.03.2021.
//  Copyright © 2021 administrator. All rights reserved.
//
//

import Foundation
import CoreData


extension Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }

    @NSManaged public var result: String?
    @NSManaged public var points: Int32

}
