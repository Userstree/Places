//
// Created by Dossymkhan Zhulamanov on 27.06.2022.
//

import UIKit

class EditLocationViewController: UIViewController {

    private var viewModel: LocationsViewModel {
        didSet {

        }
    }
    private var index: Int

    init(viewModel: LocationsViewModel, index: Int) {
        self.viewModel = viewModel
        self.index = index
        super.init(nibName: nil, bundle: nil)

        pointNameTextField.placeholder = "\(viewModel.locationsModel[index].title!)"
        pointDetailsTextField.placeholder = "\(viewModel.locationsModel[index].details)"
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    private var pointNameTextField = CustomTextField(placeholder: "CityName")

    private var pointDetailsTextField = CustomTextField(placeholder: "CityLocation")

    private func configureNavBar() {
        title = "Edit"
        navigationController?.navigationBar.backgroundColor = .white.withAlphaComponent(0.2)

        let doneNavItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneNavBarItemTapped) )
        let cancelNavItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNavBarItemTapped))
        navigationItem.rightBarButtonItem = doneNavItem
        navigationItem.leftBarButtonItem = cancelNavItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavBar()
        configureViews()
    }

    @objc private func doneNavBarItemTapped() {
        viewModel.changeLocationInfo(title: pointNameTextField.text, details: pointDetailsTextField.text, index: index)
        dismiss(animated: true)
    }

    @objc private func cancelNavBarItemTapped() {
        dismiss(animated: true)
    }

    private func configureViews() {
        [pointNameTextField, pointDetailsTextField].forEach(view.addSubview)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            pointNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pointNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pointNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pointNameTextField.heightAnchor.constraint(equalToConstant: 25),

            pointDetailsTextField.topAnchor.constraint(equalTo: pointNameTextField.bottomAnchor, constant: 20),
            pointDetailsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pointDetailsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pointDetailsTextField.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
