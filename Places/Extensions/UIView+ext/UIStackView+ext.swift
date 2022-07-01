//
// Created by Dossymkhan Zhulamanov on 21.06.2022.
//

import UIKit

extension UIStackView {
    convenience init(viewElements: [UIView]) {
        self.init()
        alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        for element in viewElements {
            addArrangedSubview(element)
        }
    }
}
