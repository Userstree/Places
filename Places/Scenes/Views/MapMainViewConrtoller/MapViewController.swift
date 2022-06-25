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

    init(viewModel: CitiesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        return tableView
    }()

    private let manager = CLLocationManager()

    private var viewModel: CitiesViewModel

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        return map
    }()

    private lazy var backButton: UIButton = {
        let button = TransitionButton().makeButton(withImage: UIImage(systemName: "arrow.backward")!)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var forwardButton: UIButton = {
        let button = TransitionButton().makeButton(withImage: UIImage(systemName: "arrow.forward")!)
        button.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsHStack: UIStackView = {
        let stack = UIStackView(viewElements: [backButton, forwardButton])
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

    private lazy var modeHStack: UIStackView = {
        let stack = UIStackView(viewElements: [mapModeSegmentedControl])
        return stack
    }()

    private lazy var mainVStack: UIStackView = {
        let stack = UIStackView(viewElements: [buttonsHStack,modeHStack])
        stack.alignment = .fill
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

        let datasource = CityTableViewDataSource()
        tableView.dataSource = datasource

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

    @objc private func citiesNavBarItemTapped() {

    }

    @objc private func backButtonTapped() {
        print("go back")
    }

    @objc private func forwardButtonTapped() {
        print("go forward")
    }

    private func configureViews() {
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

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getCitiesList().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier,
                for: indexPath) as! CityTableViewCell
        cell.configure(with: )
        return cell
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCity(city: cities[indexPath.row])
            tableView.reloadData()
        }
    }
}
