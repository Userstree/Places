//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit


typealias CitiesModel = [CityItem]

class CityItem {
//    var id = UUID().uuidString
    var name: String
    var details: String
    var coordinate: CLLocation

    init(cityName: String, cityPlace: String, coordinates: CLLocation) {
        self.name = cityName
        self.coordinate = coordinates
        self.details = cityPlace
    }
}
