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

        let viewModel:LocationsViewModel = DefaultLocationsViewModel()
        return MasterViewController(viewModel: viewModel)
    }
}
