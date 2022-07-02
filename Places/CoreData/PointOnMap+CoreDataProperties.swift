//
//  PointOnMap+CoreDataProperties.swift
//  Places
//
//  Created by Dossymkhan Zhulamanov on 01.07.2022.
//
//

import Foundation
import CoreData
import MapKit


public extension PointOnMap {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PointOnMap> {
        NSFetchRequest<PointOnMap>(entityName: "PointOnMap")
    }

    @NSManaged var title: String
    @NSManaged var details: String
    @NSManaged var longitude: Double
    @NSManaged var latitude: Double

    public var location: Location {
        Location(
                title: title,
                details: details,
                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        )
    }

    public var location2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
//
//    public var wrappedDetails: String {
//        details ?? "Unknown details"
//    }
}

extension PointOnMap : Identifiable {

}
