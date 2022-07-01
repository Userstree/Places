//
// Created by Dossymkhan Zhulamanov on 29.06.2022.
//

import UIKit

class ChangeLocationButton: UIButton {
    init(image: UIImage) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setImage(image, for: .normal)
        setContentHuggingPriority(.defaultHigh + 10, for: .horizontal)
        layer.cornerRadius = 45 / 2
        backgroundColor = .white
        addShadow(offset: CGSize(width: 2, height: 2), color: .systemGray2, radius: 3, opacity: 0.8)
        tintColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}