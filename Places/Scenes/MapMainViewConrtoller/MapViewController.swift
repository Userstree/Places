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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let manager = CLLocationManager()

    private lazy var mapView: MKMapView = {
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
        button.setContentHuggingPriority(.defaultHigh + 10, for: .horizontal)
        button.layer.cornerRadius = 45 / 2
        button.backgroundColor = .white
        button.addShadow(offset: CGSize(width: 2, height: 2), color: .systemGray2, radius: 3, opacity: 0.8)
        button.tintColor = .black
        return button
    }()

    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        button.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 45 / 2
        button.backgroundColor = .white
        button.addShadow(offset: CGSize(width: 2, height: 2), color: .systemGray2, radius: 3, opacity: 0.8)
        button.tintColor = .black
        return button
    }()

    private var buttonsHStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .horizontal
        return stack
    }()

    private var mapModeSegmentedControl: UISegmentedControl = {
        let modes: [String] = ["Standard", "Satellite", "Hybrid"]
        let segmentedControl = UISegmentedControl(items: modes)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapModeSegmentedControlChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private var modeHStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()

    private var mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()

    private func configureNavigationBar() {

        title = "red"
        navigationController?.navigationBar.backgroundColor = .white.withAlphaComponent(0.2)

        let cities = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(citiesNavBarItemTapped))
        navigationItem.rightBarButtonItem = cities
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
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
        mapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }

    @objc private func mapModeSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = .standard
        } else if sender.selectedSegmentIndex == 1 {
            mapView.mapType = .satellite

        } else {
            mapView.mapType = .hybrid
        }
    }

    @objc private func citiesNavBarItemTapped() {
        let cities = CitiesViewController(viewModel: <#T##CitiesViewModel##Places.CitiesViewModel#>)
    }

    @objc private func backButtonTapped() {
        print("go back")
    }

    @objc private func forwardButtonTapped() {
        print("go forward")
    }

    private func configureViews() {
        modeHStack.addArrangedSubview(mapModeSegmentedControl)
        [backButton, forwardButton].forEach(buttonsHStack.addArrangedSubview)
        [buttonsHStack,modeHStack].forEach(mainVStack.addArrangedSubview)

        [mapView, mainVStack].forEach(view.addSubview)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backButton.heightAnchor.constraint(equalToConstant: 45),
            backButton.widthAnchor.constraint(equalToConstant: 45),

            forwardButton.heightAnchor.constraint(equalToConstant: 45),
            forwardButton.widthAnchor.constraint(equalToConstant: 45),

            mainVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainVStack.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
}
