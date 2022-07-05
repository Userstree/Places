//
// Created by Dossymkhan Zhulamanov on 25.06.2022.
//

import UIKit
import CoreData

class MasterViewController: UIViewController, NSFetchedResultsControllerDelegate {

    private let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext

    private lazy var dataProvider: PointOnMapProvider = {
        let provider = PointOnMapProvider(with: managedContext, fetchedResultsControllerDelegate: self)
        return provider
    }()

    private var viewModel: LocationsViewModel

    init(viewModel: LocationsViewModel) {
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

    private lazy var mapViewController = MapViewController(viewModel: viewModel)

    private lazy var placesTableViewController = LocationsTableViewController(viewModel: viewModel)

    override func loadView() {
        super.loadView()
        viewModel.dataProvider = dataProvider
        placesTableViewController.dataManager.delegate = self
        viewModel.loadLocations()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        placesTableViewController.delegate = self
        mapViewController.delegate = self
        configureNavigationBar()
        setupChildViewControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCitiesTableViewEnabled = false
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewModel.updateLocationCallback = { [weak self] title in
            guard let self = self else { return }
            self.title = title
        }
    }

    private func configureNavigationBar() {
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
        title = viewModel.pointsOnMap?[index].title
    }
}

extension MasterViewController: LocationsTableViewControllerDelegate {
    func didSelectItemAt(_ index: Int) {
        mapViewController.locationIndex = index
        isCitiesTableViewEnabled = !isCitiesTableViewEnabled
    }
}
