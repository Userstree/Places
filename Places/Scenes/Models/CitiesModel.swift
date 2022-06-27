//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit

typealias CitiesModel = [CityItem]

class CityItem {
    var cityName: String
    var coordinates: CLLocation

    init(cityName: String, coordinates: CLLocation) {
        self.cityName = cityName
        self.coordinates = coordinates
    }
}
