//
// Created by Dossymkhan Zhulamanov on 25.06.2022.
//

import UIKit

class CityChangeButtons: UIViewController {

    private lazy var backButton: UIButton = {
        let button = UIButton().makeButton(withImage: UIImage(systemName: "arrow.backward")!)

        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var forwardButton: UIButton = {
        let button = UIButton().makeButton(withImage: UIImage(systemName: "arrow.forward")!)
        button.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var buttonsHStack: UIStackView = {
        let stack = UIStackView(viewElements: [backButton, forwardButton])
        stack.distribution = .equalSpacing
        stack.backgroundColor = .systemGray3
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }

    @objc private func backButtonTapped() {
        print("go back")
    }

    @objc private func forwardButtonTapped() {
        print("go forward")
    }

    private func configureViews() {
        view.addSubview(buttonsHStack)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 45),
            backButton.widthAnchor.constraint(equalToConstant: 45),

            forwardButton.heightAnchor.constraint(equalToConstant: 45),
            forwardButton.widthAnchor.constraint(equalToConstant: 45),
        ])
    }
}