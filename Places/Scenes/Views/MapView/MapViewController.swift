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

    private func configureViews() {
        [mapView].forEach(view.addSubview)
        makeConstraints()
    }

    private func makeConstraints() {

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

//            mainVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            mainVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            mainVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            mainVStack.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {  }
