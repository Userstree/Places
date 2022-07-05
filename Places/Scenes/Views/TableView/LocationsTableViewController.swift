//
// Created by Dossymkhan Zhulamanov on 26.06.2022.
//

import UIKit


class LocationsTableViewController: UIViewController {

    var dataManager: LocationsDataManager

    weak var delegate: LocationsTableViewControllerDelegate?

    private var viewModel: LocationsViewModel

    init(viewModel: LocationsViewModel) {
        self.viewModel = viewModel
        dataManager = LocationsDataManager(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    private lazy var citiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .gray.withAlphaComponent(0.7)
        tableView.delegate = dataManager
        tableView.dataSource = dataManager
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    private func configureViews() {
        view.addSubview(citiesTableView)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            citiesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            citiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            citiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            citiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
