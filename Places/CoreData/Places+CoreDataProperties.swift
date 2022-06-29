//
// Created by Dossymkhan Zhulamanov on 28.06.2022.
//

import CoreData
import Foundation
import MapKit

public extension AllPlaces {
    @nonobjc class func fetchRequest() -> NSFetchRequest<AllPlaces> {
        NSFetchRequest<AllPlaces>(entityName: "Places")
    }

    @NSManaged var title: String?
    @NSManaged var details: String?
    @NSManaged var latitude: NSNumber!
    @NSManaged var longitude: NSNumber!

    internal class func createOrUpdate(item: Point, with stack: CoreDataStack) {

        let pointTitle = item.title
        var currentPlace: AllPlaces? // Entity name
        let newsPostFetch: NSFetchRequest<AllPlaces> = AllPlaces.fetchRequest()
        if let pointTitle = pointTitle {
            let newsItemIDPredicate = NSPredicate(format: "%K == %i", #keyPath(AllPlaces.title), pointTitle)
            newsPostFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newsItemIDPredicate])
        }

        do {
            let results = try stack.managedContext.fetch(newsPostFetch)
            if results.isEmpty {
                // News post not found, create a new.
                currentPlace = AllPlaces(context: stack.managedContext)

                    currentPlace?.title = (pointTitle)

            } else {
                // News post found, use it.
                currentPlace = results.first
            }

            currentPlace?.update(item: item)
        } catch let error as NSError {

            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }

    internal func update(item: Point) {
        // Title
        title = item.title
        // Details
        details = item.details
        // Coordinates
        latitude = item.coordinate.latitude as NSNumber
        longitude = item.coordinate.longitude as NSNumber
    }
}

extension AllPlaces: Identifiable {}
