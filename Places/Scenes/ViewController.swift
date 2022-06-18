//
//  ViewController.swift
//  Places
//
//  Created by Dossymkhan Zhulamanov on 18.06.2022.
//
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let manager = CLLocationManager()

    private lazy var map: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        return map
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        button.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        return button
    }()

    private var locationName: UISegmentedControl = {
        let modes: [String] = ["Standart", "Satellite", "Hybrid"]
        let segmentedControl = UISegmentedControl(items: modes)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.setContentHuggingPriority(UILayoutPriority(1000.0), for: .horizontal)
        return segmentedControl
    }()

    private var locationHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first{
            manager.stopUpdatingLocation()

            render(location)
        }
    }

    private func render(_ location: CLLocation) {

        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        map.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        map.addAnnotation(pin)
    }

    @objc private func backButtonTapped() {
        print("go back")
    }

    @objc private func forwardButtonTapped() {
        print("go forward")
    }

    private func configureViews() {
        view.addSubview(map)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.topAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
