//
// Created by Dossymkhan Zhulamanov on 05.07.2022.
//

import UIKit


protocol LocationsTableViewControllerDelegate: AnyObject {
    func didSelectItemAt(_ index: Int)
}

class LocationsDataManager: NSObject {
    private var viewModel: LocationsViewModel
    weak var delegate: LocationsTableViewControllerDelegate?

    init(viewModel: LocationsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}

extension LocationsDataManager: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = viewModel.pointsOnMap?.count else {
            fatalError("guard failure handling has not been implemented")
        }
        return count
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

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier,
                for: indexPath) as! CityTableViewCell
        cell.configure(with: viewModel.pointsOnMap![indexPath.section].location)
        cell.backgroundColor = .systemBackground
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension LocationsDataManager: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectItemAt(indexPath.section)
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removePoint(point: viewModel.pointsOnMap![indexPath.section])
            tableView.reloadData()
        }
    }
}

