//
// Created by Dossymkhan Zhulamanov on 29.06.2022.
//

import MapKit
import UIKit

protocol LocationsTableViewCellDataSource {
    var title: String? { get set }
    var details: String { get set }
    var coordinate: CLLocationCoordinate2D { get set }
}

public class Location: NSObject, MKAnnotation, LocationsTableViewCellDataSource {
    public var title: String?
    public var details: String
    public var coordinate: CLLocationCoordinate2D

    init(title: String, details: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        self.details = details
    }

    static let identifier = "Point"
}