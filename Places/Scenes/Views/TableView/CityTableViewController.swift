//
// Created by Dossymkhan Zhulamanov on 26.06.2022.
//

import UIKit

class CityTableViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let datasource = CityTableViewDataSource()
        tableView.dataSource = datasource
    }
}
