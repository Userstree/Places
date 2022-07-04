//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit
import CoreData

protocol LocationsViewModel {
    var updateLocationCallback: LocationsCallback?  { get set }
    var dataProvider:           PointOnMapProvider! { get set }
    var pointsOnMap:            [PointOnMap]?       { get set }
    func appendPoint(point: PointOnMap)
    func removePoint(point: PointOnMap)
    func changeLocationInfo(title: String?, details: String?, index: Int)
}

final class DefaultLocationsViewModel: LocationsViewModel {

    var dataProvider: PointOnMapProvider!

    var updateLocationCallback: LocationsCallback?

    var pointsOnMap: [PointOnMap]?

    func loadLocations() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.coreDataStack.managedContext

//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
//        do {
//            locations = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
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
    }

    func removePoint(point: PointOnMap) {
        pointsOnMap = pointsOnMap?.filter {
            $0 !== point
        }
    }
}
