//
// Created by Dossymkhan Zhulamanov on 28.06.2022.
//

import UIKit

protocol AddPlaceActivityProtocol {
    func presentAddPlaceActivity()
}

extension AddPlaceActivityProtocol where Self: UIViewController {
    func presentAddPlaceActivity() {
        let alert = UIAlertController(title: "Add Place",message: nil, preferredStyle: .alert)

        alert.addTextField { field in
            field.placeholder = "Type city"
        }

        alert.addTextField { field in
            field.placeholder = "Type name of the place"
        }

        alert.addAction(.init(title: "Add", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}
