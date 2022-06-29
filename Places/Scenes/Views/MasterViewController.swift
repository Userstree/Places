//
// Created by Dossymkhan Zhulamanov on 25.06.2022.
//

import UIKit

class MasterViewController: UIViewController {

    private var viewModel: PointsViewModel

    init(viewModel: PointsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    private var isCitiesTableViewEnabled: Bool = false {
        didSet {
            if isCitiesTableViewEnabled {
                add(placesTableViewController, frame: view.frame)
            } else {
                placesTableViewController.remove()
                add(mapViewController, frame: view.frame)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCitiesTableViewEnabled = false
    }

    private lazy var mapViewController = MapViewController(viewModel: viewModel)

    private lazy var placesTableViewController = PlacesTableViewController(viewModel: viewModel)

    override func viewDidLoad() {
        super.viewDidLoad()

        placesTableViewController.delegate = self
        mapViewController.delegate = self
        configureNavigationBar()
        setupChildViewControllers()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewModel.updateLocationCallback = { [weak self] title in
            guard let self = self else { return }
            self.title = title
        }
    }

    private func configureNavigationBar() {
        title = viewModel.pointsModel[mapViewController.locationIndex].title
        navigationController?.navigationBar.backgroundColor = .white.withAlphaComponent(0.4)
        let cities = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(citiesBookNavBarItemTapped))
        navigationItem.rightBarButtonItem = cities
    }

    @objc private func citiesBookNavBarItemTapped() {
        isCitiesTableViewEnabled = !isCitiesTableViewEnabled
    }

    private func setupChildViewControllers() {
        add(mapViewController, frame: self.view.frame)
    }
}

extension MasterViewController: MapViewControllerDelegate {
    func locationIndexDidChange(_ index: Int) {
        title = viewModel.pointsModel[index].title
    }
}

extension MasterViewController: PlacesTableViewControllerDelegate {
    func didSelectItemAt(_ index: Int) {
        mapViewController.locationIndex = index
        isCitiesTableViewEnabled = !isCitiesTableViewEnabled
    }
}