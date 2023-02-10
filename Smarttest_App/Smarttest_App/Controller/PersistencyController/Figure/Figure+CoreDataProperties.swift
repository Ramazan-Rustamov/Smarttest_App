//
//  Figure+CoreDataProperties.swift
//  Smarttest_App
//
//  Created by Ramazan Rustamov on 10.02.23.
//
//

import Foundation
import CoreData


extension Figure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Figure> {
        return NSFetchRequest<Figure>(entityName: "Figure")
    }

    @NSManaged public var title: String
    @NSManaged public var height: Float
    @NSManaged public var width: Float
    @NSManaged public var pointX: Float
    @NSManaged public var pointY: Float
    @NSManaged public var colourRed: Float
    @NSManaged public var colourGreen: Float
    @NSManaged public var colourBlue: Float

}

extension Figure : Identifiable {

}
