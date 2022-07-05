//
// Created by Dossymkhan Zhulamanov on 27.06.2022.
//

import UIKit

protocol EditLocationViewControllerDelegate: AnyObject {
    func deletePin(_ pointOnMap: PointOnMap)
}

class EditLocationViewController: UIViewController {
    private let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    private let persistentContainer = AppDelegate.sharedAppDelegate.coreDataStack

    var viewModel: LocationsViewModel

    private var pointOnMap: PointOnMap!

    init(pointOnMapIndex: Int, viewModel: LocationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        guard let location = viewModel.pointsOnMap?[pointOnMapIndex] else {
            return
        }
        pointOnMap = location
        pointNameTextField.placeholder = "\(location.title)"
        pointDetailsTextField.placeholder = "\(location.details)"
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    weak var delegate: EditLocationViewControllerDelegate?

    private var pointNameTextField = CustomTextField(placeholder: "CityName")

    private var pointDetailsTextField = CustomTextField(placeholder: "CityLocation")

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 9
        button.backgroundColor = .systemRed
        return button
    }()

    private func configureNavBar() {
        title = "Edit"
        navigationController?.navigationBar.backgroundColor = .white.withAlphaComponent(0.2)

        let doneNavItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneNavBarItemTapped))
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
        managedContext.setValue(pointNameTextField.text, forKey: LocationEnum.title.rawValue)
        managedContext.setValue(pointDetailsTextField.text, forKey: LocationEnum.details.rawValue)
        managedContext.setValue(pointOnMap.latitude, forKey: LocationEnum.latitude.rawValue)
        managedContext.setValue(pointOnMap.longitude, forKey: LocationEnum.longitude.rawValue)
        persistentContainer.saveContext()
        dismiss(animated: true)
    }

    @objc private func cancelNavBarItemTapped() {
        dismiss(animated: true)
    }

    @objc private func deleteButtonTapped() {
        managedContext.delete(pointOnMap)
//        persistentContainer.saveContext()
        delegate?.deletePin(pointOnMap)
        viewModel.removePoint(point: pointOnMap)
        dismiss(animated: true)
    }

    private func configureViews() {
        [pointNameTextField, pointDetailsTextField, deleteButton].forEach(view.addSubview)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            pointNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pointNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pointNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pointNameTextField.heightAnchor.constraint(equalToConstant: 32),

            pointDetailsTextField.topAnchor.constraint(equalTo: pointNameTextField.bottomAnchor, constant: 20),
            pointDetailsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pointDetailsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pointDetailsTextField.heightAnchor.constraint(equalToConstant: 32),

            deleteButton.topAnchor.constraint(equalTo: pointDetailsTextField.bottomAnchor, constant: 20),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 75),
            deleteButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}

