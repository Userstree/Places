//
// Created by Dossymkhan Zhulamanov on 21.06.2022.
//

import UIKit
import MapKit

protocol FactoryProtocol {
    func make() -> UIViewController
}

final class Factory: FactoryProtocol {
    func make() -> UIViewController {
        let model = [
            CityItem(cityName: "Almaty", cityPlace: "KBTU", coordinates: CLLocation(latitude: 43.238949, longitude: 76.889709)),
            CityItem(cityName: "Astana", cityPlace: "NU",coordinates: CLLocation(latitude: 51.169392, longitude: 71.449074)),
            CityItem(cityName: "Aktau", cityPlace: "Sea",coordinates: CLLocation(latitude: 43.693695, longitude: 51.260834))
        ]



        let viewModel:CitiesViewModel = DefaultCitiesViewModel(model: model)
        return MasterViewController(viewModel: viewModel)
    }
}
