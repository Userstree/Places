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
            Location(title: "Almaty", details: "KBTU", coordinate: CLLocationCoordinate2D(latitude: 43.238949, longitude: 76.889709)),
            Location(title: "Astana", details: "NU", coordinate: CLLocationCoordinate2D(latitude: 51.169392, longitude: 71.449074)),
            Location(title: "Aktau", details: "Sea", coordinate: CLLocationCoordinate2D(latitude: 43.693695, longitude: 51.260834))
        ]

        let viewModel:LocationsViewModel = DefaultLocationsViewModel(model: model)
        return MasterViewController(viewModel: viewModel)
    }
}
