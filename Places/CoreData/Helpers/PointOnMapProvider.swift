//
// Created by Dossymkhan Zhulamanov on 02.07.2022.
//

import Foundation
import CoreData

protocol PointOnMapProvidable {
    init(with managedObjectContext: NSManagedObjectContext, fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate)
    var fetchedResultsController: NSFetchedResultsController<PointOnMap> { get set }
    var managedObjectContext: NSManagedObjectContext { get set }
}

class PointOnMapProvider: PointOnMapProvidable {
    var managedObjectContext: NSManagedObjectContext
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?

    required init(with managedObjectContext: NSManagedObjectContext, fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate) {
        self.managedObjectContext = managedObjectContext
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }

    lazy var fetchedResultsController: NSFetchedResultsController<PointOnMap> = {
        let fetchRequest: NSFetchRequest<PointOnMap> = PointOnMap.createFetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(PointOnMap.title), ascending: false)]
        let controller = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: managedObjectContext,
                sectionNameKeyPath: nil,
                cacheName: nil
        )
        controller.delegate = fetchedResultsControllerDelegate

        do {
            try controller.performFetch()
        } catch {
            print("Failed to fetch")
        }
        return controller
    }()

    func delete() {
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .delete:
                print("eraerg")
            default:
                break
            }
        }
    }
}
