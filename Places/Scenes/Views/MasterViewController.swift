//
// Created by Dossymkhan Zhulamanov on 25.06.2022.
//

import UIKit

class MasterViewController: UIViewController {

    private var viewModel: CitiesViewModel

    init(viewModel: CitiesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    private lazy var mapViewController: MapViewController = {
        let controller = MapViewController(viewModel: viewModel)
//        controller.view.frame = view.bounds
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildViewController()
    }

    private func configureNavigationBar() {

        title = "red"
        navigationController?.navigationBar.backgroundColor = .white.withAlphaComponent(0.2)

        let cities = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(citiesNavBarItemTapped))
        navigationItem.rightBarButtonItem = cities
    }

    @objc private func citiesNavBarItemTapped() {

    }

    private func setupChildViewController() {

    }
}
