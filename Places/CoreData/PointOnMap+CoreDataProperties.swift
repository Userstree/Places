//
//  PointOnMap+CoreDataProperties.swift
//  Places
//
//  Created by Dossymkhan Zhulamanov on 01.07.2022.
//
//

import Foundation
import CoreData


extension PointOnMap {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PointOnMap> {
        return NSFetchRequest<PointOnMap>(entityName: "PointOnMap")
    }

    @NSManaged public var title: String
    @NSManaged public var details: String
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    
//    public var wrappedTitle: String {
//        title ?? "Unkown title"
//    }
//
//    public var wrappedDetails: String {
//        details ?? "Unknown details"
//    }
}

extension PointOnMap : Identifiable {

}
