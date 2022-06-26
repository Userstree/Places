//
// Created by Dossymkhan Zhulamanov on 26.06.2022.
//

import UIKit

protocol MapModeDelegate {
    func picker(movedTo value: Int)
}

class MapModeSegmentedControl: UIViewController {

    private var mapModeSegmentedControl: UISegmentedControl = {
        let modes: [String] = ["Standard", "Satellite", "Hybrid"]
        let segmentedControl = UISegmentedControl(items: modes)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapModeSegmentedControlChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private lazy var mapModeHStack: UIStackView = {
        let stack = UIStackView(viewElements: [mapModeSegmentedControl])
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @objc private func mapModeSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
//            mapView.mapType = .standard
//            mapModeSegmentedControl.backgroundColor = .clear
        } else if sender.selectedSegmentIndex == 1 {
//            mapView.mapType = .satellite
//            mapModeSegmentedControl.backgroundColor = .white
        } else {
//            mapView.mapType = .hybrid
//            mapModeSegmentedControl.backgroundColor = .white
        }
    }
}
