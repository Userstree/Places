//
// Created by Dossymkhan Zhulamanov on 21.06.2022.
//

import UIKit

protocol CityChangeable {
    func makeButton(withImage image: UIImage) -> UIButton
}

extension CityChangeable where Self: UIButton {
    func makeButton(withImage image: UIImage) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.setContentHuggingPriority(.defaultHigh + 10, for: .horizontal)
        button.layer.cornerRadius = 45 / 2
        button.backgroundColor = .white
        button.addShadow(offset: CGSize(width: 2, height: 2), color: .systemGray2, radius: 3, opacity: 0.8)
        button.tintColor = .black
        return button
    }
}

internal class CityChangeButton: UIButton, CityChangeable { }



