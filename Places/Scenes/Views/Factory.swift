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
            Point(title: "Almaty", details: "KBTU", coordinate: CLLocationCoordinate2D(latitude: 43.238949, longitude: 76.889709)),
            Point(title: "Astana", details: "NU", coordinate: CLLocationCoordinate2D(latitude: 51.169392, longitude: 71.449074)),
            Point(title: "Aktau", details: "Sea", coordinate: CLLocationCoordinate2D(latitude: 43.693695, longitude: 51.260834))
        ]

        let viewModel:PointsViewModel = DefaultPointsViewModel(model: model)
        return MasterViewController(viewModel: viewModel)
    }
}
