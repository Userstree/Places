//
// Created by Dossymkhan Zhulamanov on 27.06.2022.
//

import UIKit
import CoreData

//class PlacesProvider{
//    private(set) var managedObjectContext: NSManagedObjectContext
//    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
//
//    init(with managedObjectContext: NSManagedObjectContext,
//         fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?)
//    {
//        self.managedObjectContext = managedObjectContext
//        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
//    }
//
//    /**
//     A fetched results controller for the NewsPosts entity, sorted by date.
//     */
//    lazy var fetchedResultsController: NSFetchedResultsController<AllPlaces> = {
//        let fetchRequest: NSFetchRequest<AllPlaces> = AllPlaces.fetchRequest()
////        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(All), ascending: false)]
//
//        let controller = NSFetchedResultsController(
//                fetchRequest: fetchRequest, managedObjectContext: managedObjectContext,
//                sectionNameKeyPath: nil,
//                cacheName: nil)
//        controller.delegate = fetchedResultsControllerDelegate
//
//        do {
//            try controller.performFetch()
//        } catch {
//            print("Fetch failed")
//        }
//
//        return controller
//    }()
//}
