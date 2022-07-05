//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit
import CoreData

protocol LocationsViewModel {
    var updateLocationCallback: LocationsCallback? { get set }
    var dataProvider: PointOnMapProvider! { get set }
    var pointsOnMap: [PointOnMap]? { get set }
    func loadLocations()
    func appendPoint(point: PointOnMap)
    func removePoint(point: PointOnMap)
    func changeLocationInfo(title: String?, details: String?, index: Int)
}

final class DefaultLocationsViewModel: LocationsViewModel {
    private let persistentContainer = AppDelegate.sharedAppDelegate.coreDataStack

    var dataProvider: PointOnMapProvider!

    var updateLocationCallback: LocationsCallback?

    var pointsOnMap: [PointOnMap]?

    func loadLocations() {
        if let objects = dataProvider.fetchedResultsController.fetchedObjects {
            pointsOnMap = objects
        }
    }

    func changeLocationInfo(
            title: String? = nil,
            details: String? = nil,
            index: Int
    ) {
        if let title = title {
            pointsOnMap?[index].title = title
        }

        if let details = details {
            pointsOnMap?[index].details = details
        }
        updateLocationCallback?(title!)
    }

    func appendPoint(point: PointOnMap) {
        pointsOnMap?.append(point)
        persistentContainer.saveContext()
    }

    func removePoint(point: PointOnMap) {
        pointsOnMap = pointsOnMap?.filter {
            $0 !== point
        }
        persistentContainer.saveContext()
    }
}
