//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit

protocol CitiesViewModel {
    func appendCity(city: City)
    func getCitiesList() -> [City]
    func removeCity(city: City)
    var updateCitiesCallback: CitiesUpdatedCallback? { get set }
}

typealias CitiesUpdatedCallback = () -> ()

final class DefaultCitiesViewModel: CitiesViewModel {

    private var citiesModel: [City] = []
    var updateCitiesCallback: CitiesUpdatedCallback?

    init(model: [City]) {
        citiesModel = model
    }

    func getCitiesList() -> [City] {
        citiesModel
    }

    func appendCity(city: City) {
        citiesModel.append(city)
        updateCitiesCallback?()
    }

    func removeCity(city: City) {
        citiesModel = citiesModel.filter { $0 !== city }
        updateCitiesCallback?()
    }
}