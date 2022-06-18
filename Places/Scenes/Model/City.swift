//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit

struct Coordinates {
    var latitude: String
    var longitude: String
}

class City {
    var cityName: String
    var cityLocation: String
    var coordinates: Coordinates

    init(cityName: String, cityLocation: String, coordinates: Coordinates) {
        self.cityName = cityName
        self.cityLocation = cityLocation
        self.coordinates = coordinates
    }
}
