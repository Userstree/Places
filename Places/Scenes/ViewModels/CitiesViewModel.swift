//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit

protocol CitiesViewModel {
    func appendCity(city: CityItem)
    func getCitiesList() -> [CityItem]
    func removeCity(city: CityItem)
    var updateLocation: CitiesCallback? { get set }
    init(model: [CityItem])
}

typealias CitiesCallback = () -> ()

final class DefaultCitiesViewModel: CitiesViewModel {

    var updateLocation: CitiesCallback?

    var citiesModel = [CityItem]() {
        didSet {
            updateLocation?()
        }
    }

    required init(model: [CityItem]) {
        citiesModel = model
    }

    func getCitiesList() -> [CityItem] {
        citiesModel
    }

    func appendCity(city: CityItem) {
        citiesModel.append(city)
        updateLocation?()
    }

    func removeCity(city: CityItem) {
        citiesModel = citiesModel.filter { $0 !== city }
        updateLocation?()
    }
}