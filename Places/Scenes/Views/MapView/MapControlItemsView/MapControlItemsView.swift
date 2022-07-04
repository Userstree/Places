//
// Created by Dossymkhan Zhulamanov on 04.07.2022.
//

import UIKit

protocol MapViewBottomItemsDelegate: AnyObject {
    func forwardButtonTapped(locationIndex: Int)
    func backButtonTapped(locationIndex: Int)
    func mapModeSegmentedControlTapped(selectedSegmentIndex: Int)
}

class MapControlItemsView: UIViewController {

    weak var delegate: MapViewBottomItemsDelegate?

    var viewModel: LocationsViewModel

    init(viewModel: LocationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("moved to bottom items")
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) hasn't been implemented")
    }

    private lazy var backwardButton: UIButton = {
        let button = ChangeLocationButton(image: UIImage(systemName: "arrow.backward")!)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var forwardButton: UIButton = {
        let button = ChangeLocationButton(image: UIImage(systemName: "arrow.forward")!)
        button.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var mapModeSegmentedControl: UISegmentedControl = {
        let modes: [String] = ["Standard", "Satellite", "Hybrid"]
        let segmentedControl = UISegmentedControl(items: modes)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapModeSegmentedControlChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    @objc private func backButtonTapped() {
        delegate?.backButtonTapped(locationIndex: -1)
    }

    @objc private func forwardButtonTapped() {
        delegate?.forwardButtonTapped(locationIndex: 1)
    }

    @objc private func mapModeSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            delegate?.mapModeSegmentedControlTapped(selectedSegmentIndex: 0)
            mapModeSegmentedControl.backgroundColor = .clear
        } else if sender.selectedSegmentIndex == 1 {
            delegate?.mapModeSegmentedControlTapped(selectedSegmentIndex: 1)
            mapModeSegmentedControl.backgroundColor = .white
        } else {
            delegate?.mapModeSegmentedControlTapped(selectedSegmentIndex: 2)
            mapModeSegmentedControl.backgroundColor = .white
        }
    }

    private func configureViews() {
        [mapModeSegmentedControl, backwardButton, forwardButton].forEach(view.addSubview)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mapModeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapModeSegmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            backwardButton.heightAnchor.constraint(equalToConstant: 45),
            backwardButton.widthAnchor.constraint(equalToConstant: 45),
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            backwardButton.bottomAnchor.constraint(equalTo: mapModeSegmentedControl.topAnchor, constant: -12),

            forwardButton.heightAnchor.constraint(equalToConstant: 45),
            forwardButton.widthAnchor.constraint(equalToConstant: 45),
            forwardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            forwardButton.bottomAnchor.constraint(equalTo: mapModeSegmentedControl.topAnchor, constant: -12),
        ])
    }
}
