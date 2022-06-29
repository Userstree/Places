//
// Created by Dossymkhan Zhulamanov on 29.06.2022.
//

import MapKit
import UIKit

protocol PointsTableViewCellDataSource {
    var title: String? { get set }
    var details: String { get set }
    var coordinate: CLLocationCoordinate2D { get set }
}

class Point: NSObject, MKAnnotation, PointsTableViewCellDataSource {
    var title: String?
    var details: String
    var coordinate: CLLocationCoordinate2D

    init(title: String, details: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        self.details = details
    }
}