//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit
import CoreData

protocol PointsViewModel {
    var pointsModel: [Point] { get }
    func appendPoint(point: Point)
    func removePoint(point: Point)
    func changePointInfo(title: String?, details: String?, index: Int)
    var updateLocationCallback: PointsCallback? { get set }
    init(model: [Point])
}

typealias PointsCallback = (String) -> ()

final class DefaultPointsViewModel: PointsViewModel {

    var points = [NSManagedObject]()

    var updateLocationCallback: PointsCallback?

    var pointsModel = [Point]()

    func loadPoints(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.coreDataStack.managedContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
        do {
            points = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func changePointInfo(title: String? = nil, details: String? = nil, index: Int) {
        if let title = title {
            pointsModel[index].title = title
        }

        if let details = details {
            pointsModel[index].details = details
        }
        updateLocationCallback?(title!)
    }

    required init(model: [Point]) {
        pointsModel = model
    }

    func appendPoint(point: Point) {
        pointsModel.append(point)
    }

    func removePoint(point: Point) {
        pointsModel = pointsModel.filter { $0 !== point }
    }
}