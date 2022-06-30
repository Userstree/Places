import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate: AnyObject {
    func locationIndexDidChange(_ index: Int)
}

class MapViewController: UIViewController, UIGestureRecognizerDelegate, AddPlaceActivityProtocol {

    weak var delegate: MapViewControllerDelegate?

    var locationIndex = 0 {
        didSet {
            if locationIndex > viewModel.pointsModel.count - 1 {
                locationIndex = 0
            }
            if locationIndex < 0 {
                locationIndex = viewModel.pointsModel.count - 1
            }
            render(viewModel.pointsModel[locationIndex].coordinate)
            delegate?.locationIndexDidChange(locationIndex)
        }
    }

    private var viewModel: PointsViewModel

    init(viewModel: PointsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
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

    private let manager = CLLocationManager()

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        map.addAnnotations(viewModel.pointsModel)
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self
        configureViews()
        longPressGesture()
    }

    private func longPressGesture() {
        let longPressGestureRec = UILongPressGestureRecognizer(target: self,
                action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGestureRec.minimumPressDuration = 0.7
        longPressGestureRec.delaysTouchesBegan = true
        longPressGestureRec.delegate = self
        mapView.addGestureRecognizer(longPressGestureRec)
    }

    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            presentAddPlaceActivity { title, details in
                let annotation = Point(title: title, details: details, coordinate: coordinate)
                self.mapView.addAnnotation(annotation)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let points = viewModel.pointsModel
        if let point = points.first {
            manager.stopUpdatingLocation()
            render(point.coordinate)
        }
    }

    private func render(_ location: CLLocationCoordinate2D) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude,
                longitude: location.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }

    @objc private func backButtonTapped() {
        locationIndex -= 1
    }

    @objc private func forwardButtonTapped() {
        locationIndex += 1
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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Point else {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Point.identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Point.identifier)
            annotationView?.canShowCallout = true
            annotationView?.loadCustomLines(customLines: [viewModel.pointsModel[locationIndex].details])
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }

    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let editVC = EditCityViewController(viewModel: viewModel, index: locationIndex)
        let navigationController = UINavigationController(rootViewController: editVC)
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(navigationController, animated: true)
    }
}
