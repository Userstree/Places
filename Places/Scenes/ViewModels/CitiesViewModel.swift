//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit

protocol CitiesViewModel {
    func appendCity(city: City)
    func getCitiesList() -> [City]
    func removeCity(city: City)
    var updateLocation: CitiesCallback? { get set }
    init(model: [City])
}

typealias CitiesCallback = () -> ()

final class DefaultCitiesViewModel: CitiesViewModel {

    var updateLocation: CitiesCallback?

    var citiesModel = [City]() {
        didSet {
            updateLocation?()
        }
    }

    required init(model: [City]) {
        citiesModel = model
    }

    func getCitiesList() -> [City] {
        citiesModel
    }

    func appendCity(city: City) {
        citiesModel.append(city)
        updateLocation?()
    }

    func removeCity(city: City) {
        citiesModel = citiesModel.filter { $0 !== city }
        updateLocation?()
    }
}