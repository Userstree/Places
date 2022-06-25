//
// Created by Dossymkhan Zhulamanov on 24.06.2022.
//

import UIKit
import CoreData

class CityStore {
    private var city: [NSManagedObject] = []
    private var cities: Cities = []

    func allCities() -> Cities {
        cities
    }

    func save(name: String) {
        guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        // 1
        let managedContext =
                appDelegate.persistentContainer.viewContext

        // 2
        let entity =
                NSEntityDescription.entity(forEntityName: "Person",
                        in: managedContext)!

        let person = NSManagedObject(entity: entity,
                insertInto: managedContext)

        // 3
        person.setValue(name, forKeyPath: "name")

        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

 }