//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit

struct Coordinates {
    var latitude: String
    var longitude: String
}

typealias Cities = [City]

class City {
    var cityName: String
    var coordinates: CLLocation

    init(cityName: String, coordinates: CLLocation) {
        self.cityName = cityName
        self.coordinates = coordinates
    }
}
