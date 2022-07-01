//
// Created by Dossymkhan Zhulamanov on 28.06.2022.
//

import UIKit

protocol AddPlaceActivityProtocol {
    func presentAddPlaceActivity(completion: @escaping (String, String) -> Void)
}

extension AddPlaceActivityProtocol where Self: UIViewController {
    func presentAddPlaceActivity(completion: @escaping (String, String) -> Void) {
        let alertController = UIAlertController(title: "Add Place",message: nil, preferredStyle: .alert)

        alertController.addTextField { field in
            field.placeholder = "Type city"
            field.delegate = self
        }
        alertController.addTextField { field in
            field.placeholder = "Type name of the place"
        }

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let titleTextField = alertController.textFields![0] as UITextField
            let detailsTextField = alertController.textFields![1] as UITextField
            if let title = titleTextField.text, let details = detailsTextField.text {
                completion(title, details)
            }
        })

        alertController.addAction(saveAction)
        alertController.view.addSubview(UIView())
        present(alertController, animated: false)
    }
}

