//
// Created by Dossymkhan Zhulamanov on 24.06.2022.
//

import UIKit
import CoreData

class CityStore {
    private var city: [NSManagedObject] = []
    private var cities: CitiesModel = []

    func allCities() -> CitiesModel {
        cities
    }

    func save(name: String) {

    }
 }