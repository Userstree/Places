//
// Created by Dossymkhan Zhulamanov on 02.07.2022.
//

import Foundation
import CoreData

class CoreDataStack {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = storeContainer.viewContext

    func edit() {

    }

    func saveContext() {
        guard managedContext.hasChanges else { return }
        print("It has changes")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}