//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit
import CoreData

protocol LocationsViewModel {
    var locationsModel: [Location] { get }
    func appendLocation(point: Location)
    func removeLocation(point: Location)
    func changeLocationInfo(title: String?, details: String?, index: Int)
    var updateLocationCallback: LocationsCallback? { get set }
    init(model: [Location])
}

typealias LocationsCallback = (String) -> ()

final class DefaultLocationsViewModel: LocationsViewModel {

    var updateLocationCallback: LocationsCallback?

    var locationsModel = [Location]()

    func loadLocations(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.coreDataStack.managedContext

//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
//        do {
//            locations = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
    }

    func changeLocationInfo(title: String? = nil, details: String? = nil, index: Int) {
        if let title = title {
            locationsModel[index].title = title
        }

        if let details = details {
            locationsModel[index].details = details
        }
        updateLocationCallback?(title!)
    }

    required init(model: [Location]) {
        locationsModel = model
    }

    func appendLocation(point: Location) {
        locationsModel.append(point)
    }

    func removeLocation(point: Location) {
        locationsModel = locationsModel.filter { $0 !== point }
    }
}
