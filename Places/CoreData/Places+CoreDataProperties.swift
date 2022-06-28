//
// Created by Dossymkhan Zhulamanov on 28.06.2022.
//

import CoreData
import Foundation
import MapKit

//public extension AllPlaces {
//    @nonobjc class func fetchRequest() -> NSFetchRequest<AllPlaces> {
//        return NSFetchRequest<AllPlaces>(entityName: "Places")
//    }
//
//    @NSManaged var id: String?
//    @NSManaged var cityName: String?
//    @NSManaged var cityPlace: String?
//    @NSManaged var coordinates: CLLocation?
//
//    internal class func createOrUpdate(item: CityItem, with stack: CoreDataStack) {
//        let newsItemID = item.id
//        var currentPlace: AllPlaces? // Entity name
//        let newsPostFetch: NSFetchRequest<AllPlaces> = AllPlaces.fetchRequest()
//        
//        let newsItemIDPredicate = NSPredicate(format: "%K == %i", #keyPath(AllPlaces.objectID), newsItemID)
//        newsPostFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newsItemIDPredicate])
//        
//        do {
//            let results = try stack.managedContext.fetch(newsPostFetch)
//            if results.isEmpty {
//                // News post not found, create a new.
//                currentPlace = AllPlaces(context: stack.managedContext)
//                
//                    currentPlace?.id = (newsItemID)
//                
//            } else {
//                // News post found, use it.
//                currentPlace = results.first
//            }
//            currentPlace?.update(item: item)
//        } catch let error as NSError {
//            print("Fetch error: \(error) description: \(error.userInfo)")
//        }
//    }
//
//    internal func update(item: CityItem) {
//        // Title
//        self.cityName = item.cityName
//        // Thumbnail
//        self.cityPlace = item.cityPlace
//        // Date
//        self.coordinates = item.coordinates
//    }
//}
//
//extension AllPlaces: Identifiable {}
