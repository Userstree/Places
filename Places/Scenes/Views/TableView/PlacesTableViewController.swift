//
// Created by Dossymkhan Zhulamanov on 26.06.2022.
//

import UIKit

protocol PlacesTableViewControllerDelegate: AnyObject {
    func didSelectItemAt(_ index: Int)
}

class PlacesTableViewController: UIViewController {

    weak var delegate: PlacesTableViewControllerDelegate?

    private var viewModel: PointsViewModel

    init(viewModel: PointsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    private lazy var citiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .gray.withAlphaComponent(0.7)
        tableView.delegate = self
        tableView.dataSource = self
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

extension PlacesTableViewController: UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.pointsModel.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        2
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectItemAt(indexPath.section)
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removePoint(point: viewModel.pointsModel[indexPath.section])
            tableView.reloadData()
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier,
                                                    for: indexPath) as! CityTableViewCell
        cell.configure(with: viewModel.pointsModel[indexPath.section] )
        cell.backgroundColor = .systemBackground
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
