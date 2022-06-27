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

class MapViewController: UIViewController {

    private var viewModel: CitiesViewModel

    init(viewModel: CitiesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    private lazy var backwardButton: UIButton = {

        let button = CityChangeButton().makeButton(withImage: UIImage(systemName: "arrow.backward")!)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var forwardButton: UIButton = {
        let button = CityChangeButton().makeButton(withImage: UIImage(systemName: "arrow.forward")!)
        button.translatesAutoresizingMaskIntoConstraints = false
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

    private let manager = CLLocationManager()

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        return map
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

        let cities = viewModel.getCitiesList()
        if let city = cities.first {
            manager.stopUpdatingLocation()

            render(city.coordinates)
        }
    }

    private func render(_ location: CLLocation) {

        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }

    @objc private func backButtonTapped() {
        print("go back")
    }

    @objc private func forwardButtonTapped() {
        print("go forward")
    }

    @objc private func mapModeSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = .standard
            mapModeSegmentedControl.backgroundColor = .clear
        } else if sender.selectedSegmentIndex == 1 {
            mapView.mapType = .satellite
            mapModeSegmentedControl.backgroundColor = .white
        } else {
            mapView.mapType = .hybrid
            mapModeSegmentedControl.backgroundColor = .white
        }
    }

    private func configureViews() {
        [mapView, mapModeSegmentedControl, backwardButton, forwardButton].forEach(view.addSubview)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

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

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
}
