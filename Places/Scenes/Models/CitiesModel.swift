//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit

protocol CityTableViewCellDataSource {
    var cityName: String { get set }
    var coordinates: CLLocation { get set }
}

typealias CitiesModel = [CityItem]

class CityItem: CityTableViewCellDataSource {
    var cityName: String
    var coordinates: CLLocation

    init(cityName: String, coordinates: CLLocation) {
        self.cityName = cityName
        self.coordinates = coordinates
    }
}
