//
// Created by Dossymkhan Zhulamanov on 28.06.2022.
//

import UIKit

protocol AddPlaceActivityProtocol {
    func presentAddPlaceActivity()
}

extension AddPlaceActivityProtocol where Self: UIViewController {
    func presentAddPlaceActivity() {
        let alertController = UIAlertController(title: "Add Place",message: nil, preferredStyle: .alert)

        alertController.addTextField { field in
            field.placeholder = "Type city"
            field.delegate = self
        }
        alertController.addTextField { field in
            field.placeholder = "Type name of the place"
        }

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            print("firstName \(firstTextField.text), secondName \(secondTextField.text)")
        })

        alertController.addAction(saveAction)
        alertController.view.addSubview(UIView())
        present(alertController, animated: false)
    }
}

//extension UIAlertController: UITextFieldDelegate {  }
