//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit

protocol CitiesViewModel {
    func appendCity(city: City)
    func getCitiesList() -> [City]
    func removeCity(city: City)
    var citiesDidChangeCallback: CitiesCallback? { get set }
    init(model: [City])
}

typealias CitiesCallback = () -> ()

final class DefaultCitiesViewModel: CitiesViewModel {

    private var citiesModel: [City] = []
    var citiesDidChangeCallback: CitiesCallback?

    required init(model: [City]) {
        citiesModel = model
    }

    func getCitiesList() -> [City] {
        citiesModel
    }

    func appendCity(city: City) {
        citiesModel.append(city)
        citiesDidChangeCallback?()
    }

    func removeCity(city: City) {
        citiesModel = citiesModel.filter { $0 !== city }
        citiesDidChangeCallback?()
    }
}