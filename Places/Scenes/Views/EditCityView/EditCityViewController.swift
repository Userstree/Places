//
// Created by Dossymkhan Zhulamanov on 27.06.2022.
//

import UIKit

class EditCityViewController: UIViewController {

    private var viewModel: PointsViewModel

    init(viewModel: PointsViewModel, atIndex: Int) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        print("\(viewModel.pointsModel[atIndex].title)")
        pointNameTextField.placeholder = "\(viewModel.pointsModel[atIndex].title!)"
        pointDetailsTextField.placeholder = "\(viewModel.pointsModel[atIndex].details)"
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    private lazy var pointNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "CityName"
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.backgroundColor = .white
        return textField
    }()

    private lazy var pointDetailsTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        textField.placeholder = "CityLocation"
        textField.backgroundColor = .white
        return textField
    }()

    private lazy var mainVStack: UIStackView = {
        let stack = UIStackView(viewElements: [pointNameTextField, pointDetailsTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .equalCentering
        stack.backgroundColor = .green
        return stack
    }()

    private func configureNavBar() {
        title = "Edit"
        navigationController?.navigationBar.backgroundColor = .white.withAlphaComponent(0.2)

        let doneNavItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneNavBarItemTapped) )
        navigationItem.rightBarButtonItem = doneNavItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemCyan
        configureNavBar()
        configureViews()
    }

    @objc private func doneNavBarItemTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    private func configureViews() {
        view.addSubview(mainVStack)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            mainVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            mainVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            mainVStack.heightAnchor.constraint(equalToConstant: 105),
        ])
    }
}

